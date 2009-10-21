Return-Path: <linux-kernel-owner+w=401wt.eu-S1754507AbZJUUUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbZJUUUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 16:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753668AbZJUUUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 16:20:19 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:43735 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151AbZJUUUS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 16:20:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=hEWNcVgkKEF9EncoaJEqcmerh6RfImENhkH3hiVKCNyWw/9Liyl5kGikoyufypftSA
         j4+70/l3PSS9mKgPqg7grh9d9YnM1ywx8s2dZcEM5bHiecAFQeshxVMIhzZOo5U5ceuL
         /zfismbf5qaIFT66RdgWHf0vaHRnTmvGhxIB4=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: =?iso-8859-15?q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>
Subject: Re: [REGRESSION] "bind" a device to a driver doesn't not 
 =?iso-8859-15?q?work=09anymore?=
Date: Wed, 21 Oct 2009 13:20:16 -0700
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc4; KDE/4.3.1; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
References: <928C125D-D36B-47C9-A549-3EE502C9EC73@gmail.com> <20091015215944.GA9845@core.coreip.homeip.net> <4ADF6237.9070004@tremplin-utc.net>
In-Reply-To: <4ADF6237.9070004@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <200910211320.16339.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 October 2009 12:34:15 pm Éric Piel wrote:
> Op 15-10-09 23:59, Dmitry Torokhov schreef:
> > Hm, this is wierd... In the dmesg you sent me in the previous mail I see:
> >
> > input: AT Raw Set 2 keyboard as
> > /devices/platform/i8042/serio0/input/input4
> >
> > So it looks like sometimes it is in raw and sometimes it is in
> > translated mode. The i8042.reset might be affecting it. Also, are you
> > using BIOS password at resume by any chance?
> >
> > I guess we'll have to wait till you get back to the box and then I want
> > fresh debug dmesgs (after poweroff) of older (with bind/unbind) and
> > latest kernels, going through boot, 1st (make sure to type qwerty) and
> > 2nd resume (qwerty again). Make sure you don't have any other i8042 or
> > atkbd switches besides i8042.debug.
> 
> Hello,
> Back with some results :-)
> 
> Attached is a (bzip-compressed) log [1] of a 2.6.30 kernel started with
> i8042.debug (nothing else important).
> 
> The log contains 4 suspend-resumes (look for "Back to C"):
> * from the console, using "echo mem > /sys/power/state", keyboard fine
> * from the console, using "pm-suspend" (aka "all the nasty stuff done by
> the distro"), keyboard fine
> * from X, using "echo mem > /sys/power/state", keyboard gone
> * a unbind-bind cycle, keyboard back
> * from X, using "echo mem > /sys/power/state", keyboard fine
> 
> 
> What I realised during this experiment, is that the keyboard goes away
> after the first suspend-resume _in X_. Each time, I typed on the
> keyboard "qwerty" (and almost nothing else).
> 
> Do you see what goes wrong in resuming the keyboard?
> 

Nothing, as far as I can tell... I see you typing "qwerty"... Does the 
keyboard work in console (let's say if you boot in run level 3 to take X out 
of the picture)? Could you please try compiling evbug module - it will show if 
keyboard events are propagated through input core. Also, whta driver are you 
using in X? Legacy keyboard or evdev?

-- 
Dmitry
