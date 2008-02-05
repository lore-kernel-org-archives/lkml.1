Return-Path: <linux-kernel-owner+w=401wt.eu-S1752839AbYBELWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbYBELWw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 06:22:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750864AbYBELWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 06:22:44 -0500
Received: from styx.suse.cz ([82.119.242.94]:59298 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750805AbYBELWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 06:22:44 -0500
Date: Tue, 5 Feb 2008 12:22:42 +0100
From: Vojtech Pavlik <vojtech@suse.cz>
To: Javier Herrero <jherrero@hvsistemas.es>
Cc: Bryan Wu <bryan.wu@analog.com>, Will Newton <will.newton@gmail.com>,
       dmitry.torokhov@gmail.com, linux-input@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1 try#2] [INPUT] keypad driver: Added support for
	OpenCores Keyboard Controller
Message-ID: <20080205112242.GA5398@suse.cz>
References: <1201686610-31458-1-git-send-email-bryan.wu@analog.com> <87a5b0800801300353l196b39bekad6af6ccdbd49d5b@mail.gmail.com> <1201713502.8345.1.camel@roc-laptop> <20080205104242.GA11437@suse.cz> <47A845F7.8030102@hvsistemas.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47A845F7.8030102@hvsistemas.es>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2008 at 12:18:15PM +0100, Javier Herrero wrote:
> Dear Vojtech,
>
> I think that a 1:1 mapping between linux keycodes and what keyboard sends 
> is right, because the scan code to key code conversion is already 
> programmed and done inside the FPGA code.

And the FPGA code changes with different keyboards attached?

> Best regards,
>
> Javier
>
> Vojtech Pavlik escribió:
>> On Thu, Jan 31, 2008 at 01:18:22AM +0800, Bryan Wu wrote:
>>
>>> +static irqreturn_t opencores_kbd_isr(int irq, void *dev_id)
>>> +{
>>> +	unsigned char c;
>>> +	struct platform_device *pdev = dev_id;
>>> +	struct opencores_kbd *opencores_kbd = platform_get_drvdata(pdev);
>>> +	struct input_dev *input = opencores_kbd->input;
>>> +
>>> +	c = readb(opencores_kbd->addr_res->start);
>>> +	input_report_key(input, c & 0x7f, c & 0x80 ? 0 : 1);
>>> +	input_sync(input);
>>> +
>>> +	return IRQ_HANDLED;
>>> +}
>>  This looks utterly wrong: It assumes 1:1 mapping between Linux keycodes
>> and what the keyboard sends, which I can't believe is the case.
>>
>
> -- 
> ------------------------------------------------------------------------
> Javier Herrero                            EMAIL: jherrero@hvsistemas.com
> HV Sistemas S.L.                          PHONE:         +34 949 336 806
> Los Charcones, 17A                        FAX:           +34 949 336 792
> 19170 El Casar - Guadalajara - Spain      WEB: http://www.hvsistemas.com 

-- 
Vojtech Pavlik
Director SuSE Labs
