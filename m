Return-Path: <linux-kernel-owner+w=401wt.eu-S1765673AbXIUXU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765673AbXIUXU1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 19:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757631AbXIUXUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 19:20:19 -0400
Received: from smtpoutm.mac.com ([17.148.16.72]:62822 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755704AbXIUXUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 19:20:18 -0400
In-Reply-To: <878x6z67n8.fsf@jbms.ath.cx>
References: <Pine.LNX.4.44L0.0709211540100.5816-100000@iolanthe.rowland.org> <200709212253.02158.rjw@sisk.pl> <87d4wb680u.fsf@jbms.ath.cx> <200709212325.39599.rjw@sisk.pl> <878x6z67n8.fsf@jbms.ath.cx>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <BF08447B-234F-4851-89BF-92A57EA801C6@mac.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       Nigel Cunningham <nigel@nigel.suspend2.net>, nigel@suspend2.net,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       linux-pm@lists.linux-foundation.org,
       huang ying <huang.ying.caritas@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [linux-pm] Re: [RFC][PATCH 1/2 -mm] kexec based hibernation -v3: kexec jump
Date: Fri, 21 Sep 2007 19:19:18 -0400
To: Jeremy Maitin-Shepard <jbms@cmu.edu>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 21, 2007, at 17:16:59, Jeremy Maitin-Shepard wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>> The ACPI platform firmware is allowed to preserve information  
>> accross the hibernation-resume cycle, so this need not be the same.
>
> All of my comments related to the case where S4 is not being used  
> (instead the system is just powered off normally), and a boot  
> kernel that does not initialize ACPI is used.  In that case, the  
> ACPI platform firmware should not be able to distinguish a normal  
> boot from a resume from hibernation.

I think that in order for this to work, there would need to be some  
ABI whereby the resume-ing kernel can pass its entire ACPI state and  
a bunch of other ACPI-related device details to the resume-ed kernel,  
which I believe it does not do at the moment.  I believe that what  
causes problems is the ACPI state data that the kernel stores is  
*different* between identical sequential boots, especially when you  
add/remove/replace batteries, AC, etc.

Since we currently throw away most of that in-kernel ACPI interpreter  
state data when we load the to-be-resumed image and replace it with  
the state from the previous boot it looks to the ACPI code and  
firmware like our system's hardware magically changed behind its  
back.  The result is that the ACPI and firmware code is justifiably  
confused (although probably it should be more idempotent to begin  
with).  There's 2 potential solutions:
   1) Formalize and copy a *lot* of ACPI state from the resume-ing  
kernel to the resume-ed kernel.
   2) Properly call the ACPI S4 methods in the proper order

Neither one is particularly easy or particularly pleasant, especially  
given all the vendor bugs in this general area.  Theoretically we  
should be able to do both, since one will be more reliable than the  
other on different systems depending on what kinds of firmware bugs  
they have.

Cheers,
Kyle Moffett

