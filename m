Return-Path: <linux-kernel-owner+w=401wt.eu-S1030931AbXDQXJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030931AbXDQXJg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 19:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030925AbXDQXJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 19:09:36 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:45009 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030924AbXDQXJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 19:09:35 -0400
X-Greylist: delayed 840 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Apr 2007 19:09:35 EDT
Message-ID: <462553A9.70504@novell.com>
Date: Tue, 17 Apr 2007 16:09:29 -0700
From: Crispin Cowan <crispin@novell.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: David Safford <safford@watson.ibm.com>
CC: James Morris <jmorris@namei.org>, John Johansen <jjohansen@suse.de>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: AppArmor FAQ
References: <20070416213350.GB4030@suse.de>	 <Line.LNX.4.64.0704161846110.13905@d.namei> <1176822230.3366.65.camel@localhost.localdomain>
In-Reply-To: <1176822230.3366.65.camel@localhost.localdomain>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Safford wrote:
> On Mon, 2007-04-16 at 20:20 -0400, James Morris wrote:
>   
>> On Mon, 16 Apr 2007, John Johansen wrote:
>>     
>>> Label-based security (exemplified by SELinux, and its predecessors in
>>> MLS systems) attaches security policy to the data. As the data flows
>>> through the system, the label sticks to the data, and so security
>>> policy with respect to this data stays intact. This is a good approach
>>> for ensuring secrecy, the kind of problem that intelligence agencies have.
>>>       
>> Labels are also a good approach for ensuring integrity, which is one of 
>> the most fundamental aspects of the security model implemented by SELinux.  
>>
>> Some may infer otherwise from your document.
>>     
> In fact, I am not sure how you can provide integrity support without
> labels. AppArmor confines a process, but does not effectively confine 
> its output files, precisely because the output files are not labeled. 
> Other processes are free to access the unlabeled, potentially malicious 
> output files without restriction. 
>   
That depends on what you mean by "integrity." It is true that AppArmor
does not directly manage information flow. AppArmor assumes that if you
granted write permission to /etc/resolv.conf, that you meant to do that.
Whether any other process is permitted to access /etc/resolv.conf is
determined by those other process's respective profiles.

What AppArmor provides is a way for administrators to confine software
that they have to run but do not trust. The use of pathnames means that
the administrator can understand the exact meaning of the security
policy, without having to do a complete labeling of the file system. The
flip side of not managing information flow is that each profile is
independent of every other profile.

The meaning of a file is how other processes interpret it. Until then,
/etc/resolv.conf is just a quaint bag of bits. What makes it special is
that it is what each process gets when they open the well-known
"/etc/resolv.conf". Which is why it is useful to guard which processes
can read or write to /etc/resolv.conf; the name is what makes its
content special, not the other way around.

Crispin

-- 
Crispin Cowan, Ph.D.               http://crispincowan.com/~crispin/
Director of Software Engineering   http://novell.com
"You cannot say anything that is both simple and complete."--Crispin on Goedel

