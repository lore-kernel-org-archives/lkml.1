Return-Path: <linux-kernel-owner+w=401wt.eu-S1759787AbYBSTpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759787AbYBSTpn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 14:45:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752414AbYBSTpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 14:45:36 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:46500 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbYBSTpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 14:45:35 -0500
Date: Tue, 19 Feb 2008 11:45:15 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Karl Dahlke <eklhad@comcast.net>
Cc: linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com
Subject: Re: [PATCH] export getledstate()
Message-Id: <20080219114515.337c9452.randy.dunlap@oracle.com>
In-Reply-To: <20080119135723.eklhad@comcast.net>
References: <20080119135723.eklhad@comcast.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2008 13:57:23 -0500 Karl Dahlke wrote:

> I write adapters for disabled people, and we often have to do
> specialized functions based on keystrokes and key chords.
> I would like to do certain things when keys are hit and num lock is on,
> but there is no easy way to get the led state.
> There is a nice function getledstate()
> in keyboard.c, it just isn't exported.
> Here is the patch that would do that.
> Can you apply this patch, or, is there another easy way to get this information,
> or, would it be better to fold this information into keyboard_notifier_param,
> along with shift state etc.
> I use notifiers, so this would be natural, and almost as easy.
> I'd be happy to write that patch, if you think that would be a superior design.

cc Dmitry added.

I don't oppose the export, but it seems that using getledstate()
asynchronously could return out-of-sync info, while adding this info
to the notifier data would synchronize the info..
Maybe it depends on how it's done.

> 
> --- drivers/char/keyboard.c	2008-02-18 21:05:23.000000000 -0500
> +++ drivers/char/keyboard.c.new	2008-02-18 21:06:34.000000000 -0500

--- linux/drivers/char/keyboard.c.old
+++ linux/drivers/char/keyboard.c

is the preferred form.  (a) keep the top-level linux dir name.
(b) the +++ line has the correct file name.

> @@ -963,6 +963,7 @@ unsigned char getledstate(void)
>  {
>  	return ledstate;
>  }
> +EXPORT_SYMBOL_GPL(getledstate);
>  
>  void setledstate(struct kbd_struct *kbd, unsigned int led)
>  {


---
~Randy
