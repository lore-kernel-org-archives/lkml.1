Return-Path: <linux-kernel-owner+w=401wt.eu-S1946482AbXBIOgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946482AbXBIOgb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 09:36:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946483AbXBIOgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 09:36:31 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:12995 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946482AbXBIOga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 09:36:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=I3/ySxmRUTz08VGEDc+5c88pm3sFbXTlFMczxCwfwY8AS12LTktYLkaJSxPyt9qQTHHawVwRZTRqN6nlNLSmePCttmU4mhGvCmWnZezm7DG10u38dcLCksUNXtVABw7UdC2Jbk0EebZm25v+GRdVwue2rToyrUuIReTw01rfjqc=
Message-ID: <d120d5000702090636r8243772u91908d7608eae0cc@mail.gmail.com>
Date: Fri, 9 Feb 2007 09:36:28 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: frank.salomon@wincor-nixdorf.com
Subject: Re: EV_MSC / driver/input/input.c (Input Handler)
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <45CC1FA5.3090507@wincor-nixdorf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45CAE5A1.80409@wincor-nixdorf.com>
	 <d120d5000702080715u2902bc81oda4b9250892a1bf2@mail.gmail.com>
	 <45CC1FA5.3090507@wincor-nixdorf.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frank,

On 2/9/07, Frank Salomon <frank.salomon@wincor-nixdorf.com> wrote:
> Hi Dmitry,
>
> Dmitry Torokhov wrote:
>
> > That is because by default atkbd uses software-emulated raw mode.
> > bootk with atkbd.softraw=0 or switch it off after boot through sysfs
> > attribute to get EV_MSC/MSC_RAW passed through).
>
> Thank you for your advice, but I really don't know, what will be the
> secondary effect if it will be switched off.
>
> > No, input core should not pass any events device did not claim to support.
>
> I am not sure, but I think the function input_event in
> drivers/input/input.c has 2 tasks:
> One is to send events to the device (first part: "switch (type){").
>
> The other one is to send the events to the handler (second part:
> "list_for_each_entry(handle, &dev->h_list, d_node)").
>
> This is the reason why I had the idea of changing the code as I have
> described it before.
>
> With the current implementation, the device sends events to the handler.
> But only events, known/claimed by the device are passed through to the
> handler. I believe, this should be handled transparently.
>

Thta is the policy. Unless device claims to support certain events
they will not be passed through so there is no "surprises". This way
userspace applications can query device capabilities, classify them
and adjust behavior accordingly.

> > What are you trying to do though? Why are you interested in raw atkbd
> > events? What will your handler do with events from other input devices
> > that might emit raw events?
>
> I have to connected special Point Of Sales Keyboards. Sometimes they are
> sending none standard scan codes, only make codes and no break codes. I
> had successfully implemented this in kernel version 2.4 and now I have
> to do it in 2.6.
>

You probably want to use serio_raw module for that that provides raw
access to a PS/2 port (2.4-style) and possibly uinput driver to nject
parsed event stream back into kernel for standard delivery to
userspace apps.

-- 
Dmitry
