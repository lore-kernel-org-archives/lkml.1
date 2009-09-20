Return-Path: <linux-kernel-owner+w=401wt.eu-S1752677AbZITGcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbZITGcl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 02:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbZITGck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 02:32:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51994 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750797AbZITGcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 02:32:39 -0400
Date: Sat, 19 Sep 2009 23:30:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-input@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH] input/keyboard: new driver for ADP5520 MFD PMICs
Message-Id: <20090919233044.8361a912.akpm@linux-foundation.org>
In-Reply-To: <1253211850-29309-1-git-send-email-vapier@gentoo.org>
References: <1253211850-29309-1-git-send-email-vapier@gentoo.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Sep 2009 14:24:10 -0400 Mike Frysinger <vapier@gentoo.org> wrote:

> ...
> +struct adp5520_keys {
> +	struct input_dev *input;
> +	struct notifier_block notifier;
> +	struct device *master;
> +	unsigned short keycode[ADP5520_KEYMAPSIZE];

Where is ADP5520_KEYMAPSIZE defined?

I can find a single instance in the tree:

./arch/blackfin/mach-bf537/boards/stamp.c:static const unsigned short adp5520_keymap[ADP5520_KEYMAPSIZE] = {
	
is it runtime-generated or something?

> +};
> +
> +static void adp5520_keys_report_event(struct adp5520_keys *dev,
> +					unsigned short keymask, int value)
> +{
> +	int i;
> +
> +	for (i = 0; i < ADP5520_MAXKEYS; i++)

Where is ADP5520_MAXKEYS defined?

> +		if (keymask & (1 << i))
> +			input_report_key(dev->input, dev->keycode[i], value);

It seems odd that keycode is dimensioned with ADP5520_KEYMAPSIZE but
here we iterate up to ADP5520_MAXKEYS.

> +
> +	input_sync(dev->input);
> +}
> +
> ...
