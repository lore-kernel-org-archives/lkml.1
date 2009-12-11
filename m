Return-Path: <linux-kernel-owner+w=401wt.eu-S1762896AbZLKW3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762896AbZLKW3Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 17:29:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934051AbZLKW3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 17:29:20 -0500
Received: from n19.bullet.mail.mud.yahoo.com ([68.142.206.146]:21165 "HELO
	n19.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1762882AbZLKW0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 17:26:52 -0500
X-Yahoo-Newman-Id: 673582.15502.bm@omp413.mail.mud.yahoo.com
X-Yahoo-SMTP: qGLgp.mswBDSnFfWmYVMF5Rmg6NJ
X-YMail-OSG: F_iuD_0VM1kFJP124VfoYqwnJih3RxAJ9KXaC8ozUl7Qq7NT.WkpBBrv8QS2yFRmwnDESpyQLwhvoi4pV3JCCzSGITsjmGwLwUpn5R0kF4amWRbfVNi5UcMAYnZtVwPjIT9xD4bLk1fa2bRyVza8dJtu7nWmpgnDWfyYgWja4S6k0rJ.akwn_5jxzlk1xLhsDuCPuerRQGi3_78aSe2DoXOa1m.9eX.9tsErId4a8VOAAGwhiw7qfi14kBj.FW9Pt7UiLvYU8rvM_u_8Cjn1xvqm86Rt0A8DLesviWyz6sZIpU6HV.icOm20_tICwwfYcE1sCmvUuUxvb.wH.OIj394zaA_xXPztsqKxWb0h0U7YU3soHh9a546XVFpLfE.jgfABXKLf1q4-
X-Yahoo-Newman-Property: ymail-3
From: Steven King <sfking@fdwdc.com>
Organization: fdwdc.com
To: Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [PATCH][input] add Honeywell hmc5843 3-Axis Magnetometer (digital compass)  driver.
Date: Fri, 11 Dec 2009 14:26:53 -0800
User-Agent: KMail/1.9.9
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200912102250.12853.sfking@fdwdc.com> <4B223EE4.5010203@cam.ac.uk>
In-Reply-To: <4B223EE4.5010203@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912111426.54186.sfking@fdwdc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonathan,

Thanks for taking at look at it.

On Friday 11 December 2009 04:45:24 Jonathan Cameron wrote:
> Dear Steven,
>
> Mostly looks good to me.  Couple of minor comments inline below.
>
> I'd also like to see some documentation for this chip.  We don't really
> want people to have to read the data sheet in order to find out what the
> various modes and frequency settings are for example. Datasheets have
> a nasty habit of disappearing in the long run.  Probably needs something
> in Documentation directory rather than merely comments in the code.

Yeah, thats on my todo list, but I thought I should post the bare driver to 
get some feedback before I got too far along...

> Only one I'm really fussy about is making sure you use the unsigned
> strict_strtoul where appropriate.  Fix that and you can add
> Acked-by: Jonathan Cameron <jic23@cam.ac.uk>

Doh! I had originally used strict_strtoul, then for some reason I can't 
remember (probably caffeine deprivation) I changed them.  Thanks for catching 
that.

> I'm not entirely convinced this one should be in input as I can't really
> believe it is commonly used as an input device?  Over to Dmitry and others
> for that though.   We can always move it at a later date. The requirements
> of a chip this simple (interface wise) would make that trivial.

I wasn't sure either; currently, the only use I'm familiar with is to combine 
the magnetometer with an accelerometer to create a tilt compensated digital 
compass.  In practice, the raw data needs some massaging to be usefull, so 
the plan is to have a daemon that collects the inputs from the accelerometer 
and the magnetometer and does the processing and apps would talk to it, so 
I'm not fixated on any particular interface.

Anyway, I'll cobble together something for Documentation/input/ (for now) and 
fix those strict_strtol (and the ints) and respin the patch.

Thanks,
-- 
Steven King -- sfking at fdwdc dot com

