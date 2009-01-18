Return-Path: <linux-kernel-owner+w=401wt.eu-S933112AbZARAW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933112AbZARAW1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 19:22:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754884AbZARAWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 19:22:17 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:42784 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372AbZARAWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 19:22:17 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=20KFwNOVAAAA:8 a=iWsxF1SV8jYz-l9tW-YA:9 a=OrfNqEd9YjocZ0_EqT527eCK7XgA:4
Message-ID: <49727633.3000600@shaw.ca>
Date: Sat, 17 Jan 2009 18:22:11 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: David Wagner <daw@cs.berkeley.edu>
CC: linux-kernel@vger.kernel.org
Subject: Re: Checking module parameters
References: <200901172226.n0HMQEEJ024690@taverner.cs.berkeley.edu>
In-Reply-To: <200901172226.n0HMQEEJ024690@taverner.cs.berkeley.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Wagner wrote:
> Is there a way to tell what options have been applied to a currently
> loaded kernel module?
> 
> I'm trying to force libata to use 1.5Gbps rather than 3Gbps, so I created
> a file /etc/modprobe.d/local containing:
>   options libata force=1.5Gbps
> However my SATA drive gets loaded at 3Gbps.  I'm trying to figure out how
> to debug this so that I can tell whether the option got correctly applied
> to the libata module, and if not, how to force the SATA link to 1.5Gbps.
> Any suggestions or ideas?
> 
> (I can't set libata.force=1.5Gbps as a kernel argument because on my
> Fedora kernel, libata is loaded as a module rather than built into the
> kernel.  I can't run "modprobe libata force=1.5Gbps" by hand because
> I've got SATA drives, so the libata module is automatically loaded before
> I get shell access.)

Rebuilding the initrd with that option set should cause the initrd to 
pass the option into the libata module when the initrd script loads it. 
Unfortunately the current Fedora mkinitrd is broken such that this 
doesn't work. I'm rather disappointed by the lack of response to this 
bug as it seems like it should be easily resolved and causes serious 
problems with debugging certain issues, as you've found. Anyone know who 
needs to be hit with a clue-by-four to get this fixed?

https://bugzilla.redhat.com/show_bug.cgi?id=457870
