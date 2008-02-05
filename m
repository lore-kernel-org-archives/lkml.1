Return-Path: <linux-kernel-owner+w=401wt.eu-S1757270AbYBEKmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270AbYBEKmv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 05:42:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754474AbYBEKmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 05:42:44 -0500
Received: from styx.suse.cz ([82.119.242.94]:58206 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753775AbYBEKmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 05:42:43 -0500
Date: Tue, 5 Feb 2008 11:42:42 +0100
From: Vojtech Pavlik <vojtech@suse.cz>
To: Bryan Wu <bryan.wu@analog.com>
Cc: Will Newton <will.newton@gmail.com>, dmitry.torokhov@gmail.com,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       Javier Herrero <jherrero@hvsistemas.es>
Subject: Re: [PATCH 1/1 try#2] [INPUT] keypad driver: Added support for
	OpenCores Keyboard Controller
Message-ID: <20080205104242.GA11437@suse.cz>
References: <1201686610-31458-1-git-send-email-bryan.wu@analog.com> <87a5b0800801300353l196b39bekad6af6ccdbd49d5b@mail.gmail.com> <1201713502.8345.1.camel@roc-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201713502.8345.1.camel@roc-laptop>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2008 at 01:18:22AM +0800, Bryan Wu wrote:

> +static irqreturn_t opencores_kbd_isr(int irq, void *dev_id)
> +{
> +	unsigned char c;
> +	struct platform_device *pdev = dev_id;
> +	struct opencores_kbd *opencores_kbd = platform_get_drvdata(pdev);
> +	struct input_dev *input = opencores_kbd->input;
> +
> +	c = readb(opencores_kbd->addr_res->start);
> +	input_report_key(input, c & 0x7f, c & 0x80 ? 0 : 1);
> +	input_sync(input);
> +
> +	return IRQ_HANDLED;
> +}
 
This looks utterly wrong: It assumes 1:1 mapping between Linux keycodes
and what the keyboard sends, which I can't believe is the case.

-- 
Vojtech Pavlik
Director SuSE Labs
