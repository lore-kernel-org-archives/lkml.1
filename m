Return-Path: <linux-kernel-owner+w=401wt.eu-S1763704AbXIUXsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763704AbXIUXsT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 19:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757327AbXIUXsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 19:48:08 -0400
Received: from home.nigel.suspend2.net ([203.171.70.205]:53824 "EHLO
	home.nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755878AbXIUXsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 19:48:07 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
To: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [linux-pm] Re: [RFC][PATCH 1/2 -mm] kexec based hibernation -v3: kexec jump
Date: Sat, 22 Sep 2007 09:47:56 +1000
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Jeremy Maitin-Shepard <jbms@cmu.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>, nigel@suspend2.net,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       linux-pm@lists.linux-foundation.org,
       huang ying <huang.ying.caritas@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
References: <Pine.LNX.4.44L0.0709211540100.5816-100000@iolanthe.rowland.org> <878x6z67n8.fsf@jbms.ath.cx> <BF08447B-234F-4851-89BF-92A57EA801C6@mac.com>
In-Reply-To: <BF08447B-234F-4851-89BF-92A57EA801C6@mac.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709220947.58872.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Saturday 22 September 2007 09:19:18 Kyle Moffett wrote:
> I think that in order for this to work, there would need to be some  
> ABI whereby the resume-ing kernel can pass its entire ACPI state and  
> a bunch of other ACPI-related device details to the resume-ed kernel,  
> which I believe it does not do at the moment.  I believe that what  
> causes problems is the ACPI state data that the kernel stores is  
> *different* between identical sequential boots, especially when you  
> add/remove/replace batteries, AC, etc.

That's certainly possible. We already pass a very small amount of data between 
the boot and resuming kernels at the moment, and it's done quite simply - by 
putting the variables we want to 'transfer' in a nosave page/section. I could 
conceive of a scheme wherein this was extended for driver data. Since the 
memory needed would depend on the drivers loaded, it would probably require 
that the space be allocated when hibernating, and the locations of structures 
be stored in the image header and then drivers notified of the locations to 
use when preparing to resume, but it could work...
 
> Since we currently throw away most of that in-kernel ACPI interpreter  
> state data when we load the to-be-resumed image and replace it with  
> the state from the previous boot it looks to the ACPI code and  
> firmware like our system's hardware magically changed behind its  
> back.  The result is that the ACPI and firmware code is justifiably  
> confused (although probably it should be more idempotent to begin  
> with).  There's 2 potential solutions:
>    1) Formalize and copy a *lot* of ACPI state from the resume-ing  
> kernel to the resume-ed kernel.
>    2) Properly call the ACPI S4 methods in the proper order

... that said, I don't think the above should be necessary in most cases. I 
believe we're already calling the ACPI S4 methods in the proper order. If I 
understood correctly, Rafael put a lot of effort into learning what that was, 
and into ensuring it does get done.
 
> Neither one is particularly easy or particularly pleasant, especially  
> given all the vendor bugs in this general area.  Theoretically we  
> should be able to do both, since one will be more reliable than the  
> other on different systems depending on what kinds of firmware bugs  
> they have.

Regards,

Nigel
