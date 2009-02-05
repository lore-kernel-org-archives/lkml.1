Return-Path: <linux-kernel-owner+w=401wt.eu-S932472AbZBEBjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932472AbZBEBjE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 20:39:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761968AbZBEBi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 20:38:28 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:53488 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762154AbZBEBi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 20:38:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:newsgroups:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=snasCPMnCu4OXVb4wANZJHpqI/aYkr0P8veoIYLrt9YBPsYqMiWomXKserbsw5w/dx
         3zJOhY/HLh0vOyTd9a/xsVw5geDzIVE8mDq/zcIVOqbQILmgEypWKEfNPXbwCgAUbqO3
         vXyIYL3KEMkwuJmSCGtl/e68ox0pe1mghVEcU=
Message-ID: <498A430E.1040809@gmail.com>
Date: Wed, 04 Feb 2009 19:38:22 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Michael Monnerie <michael.monnerie@is.it-management.at>
CC: linux-kernel@vger.kernel.org
Subject: Re: Poor performance on cp on kernel 2.6.27.7-9-xen (openSUSE 11.1)
References: <200902050208.50490@zmi.at>
In-Reply-To: <200902050208.50490@zmi.at>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Monnerie wrote:
> And one last thing:
> rsync -aPv /disk1/bigfile /disk2/xxx
> That copies at max. 50MB/s, because 2 rsync tasks are started each 
> taking 50% of 1 CPU - why doesn't the kernel switch the 2nd task to 
> another CPU? There are 8 cpus in that system - 7 of them idle.

Usually in such cases it's because the tasks are piping data to each 
other in such a way that they can't both run at the same time. In this 
situation there is no point in moving one to another CPU because they're 
not executing concurrently anyway.
