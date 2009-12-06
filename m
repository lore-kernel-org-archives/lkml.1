Return-Path: <linux-kernel-owner+w=401wt.eu-S933882AbZLFQwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933882AbZLFQwF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 11:52:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933884AbZLFQwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 11:52:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48854 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932881AbZLFQwC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 11:52:02 -0500
Message-ID: <4B1BE136.4090005@redhat.com>
Date: Sun, 06 Dec 2009 18:52:06 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091203 Fedora/3.0-3.13.rc2.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: bifferos <bifferos@yahoo.co.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: Kexec failure on RDC (and possibly other early x86) platforms
References: <371220.64690.qm@web27006.mail.ukl.yahoo.com>
In-Reply-To: <371220.64690.qm@web27006.mail.ukl.yahoo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2009 01:33 PM, bifferos wrote:
> I've updated the patch to allow Kexec to work on RDC platforms
> here:
> http://bifferboard.svn.sourceforge.net/viewvc/bifferboard/slack/kernel/2.6.32/0003-kexec-fix.patch
>
> I'm curious as to how one can detect the presence of the CR4
> register in assembler, as I'm sure it's possible, but I've just
> #ifndefed out the offending instruction in this patch and it
> seems to work with this change.
>    

One way is to execute the instruction and trap the #UD exception if it 
is not supported.  Not sure whether you have an IDT set up or whether 
your cpu traps on mov cr4.

If your cpu supports cpuid you can test for features that indicate bits 
in cr4 are available, for example VME, DE, PSE, PVI, and PAE.  If none 
are available you likely don't have cr4 (and even if you do, it's 
pointless to reset it).

-- 
error compiling committee.c: too many arguments to function

