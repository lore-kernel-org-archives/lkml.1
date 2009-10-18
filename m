Return-Path: <linux-kernel-owner+w=401wt.eu-S1754441AbZJRISX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441AbZJRISX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 04:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752913AbZJRISV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 04:18:21 -0400
Received: from claw.goop.org ([74.207.240.146]:42326 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754305AbZJRISP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 04:18:15 -0400
Message-ID: <4ADACF48.9020907@goop.org>
Date: Sun, 18 Oct 2009 17:18:16 +0900
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>, kurt.hackel@oracle.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [GIT PULL RFC] pvclock cleanups and pvclock vsyscall support
References: <1255548516-15260-1-git-send-email-jeremy.fitzhardinge@citrix.com> <4AD6C679.3000001@redhat.com> <4AD77C21.2050506@goop.org> <4ADAB8F4.6090502@redhat.com>
In-Reply-To: <4ADAB8F4.6090502@redhat.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/09 15:43, Avi Kivity wrote:
> On 10/16/2009 04:46 AM, Jeremy Fitzhardinge wrote:
>> Care to cook up a patch to implement the kvm bits to make sure it all
>> works OK for you?
>>    
>
> I've started to do that, but it occurs to me that we're missing out on
> NUMA placement by forcing all clocks to be on the same page. OTOH, if
> the clocks are heavily used, they'll stay in cache, and if not, who
> cares.
>

Yes, I'd say so.  I'd expect the data to be very close to read-only, so
the lines should be shared pretty efficiently. 

On the other hand, there's nothing to stop us from moving to multiple
pages in future (either to support NUMA placement, or just more than 64
cpus).

    J
