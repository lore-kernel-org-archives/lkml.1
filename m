Return-Path: <linux-kernel-owner+w=401wt.eu-S1755754AbZENTzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754AbZENTzJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 15:55:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753180AbZENTy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 15:54:56 -0400
Received: from gw.goop.org ([64.81.55.164]:52198 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906AbZENTyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 15:54:55 -0400
Message-ID: <4A0C770E.2030305@goop.org>
Date: Thu, 14 May 2009 12:54:54 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>, Greg KH <gregkh@suse.de>,
       Olaf Kirch <okir@suse.de>
Subject: Where do we stand with the Xen patches?
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Over the last week or so, I've set out pull requests for the following 
branches in git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git :

for-ingo/xen/dom0/core

    You made two comments about the first post of this set:

       1. The // comments in the mtrr code.  Now fixed.
       2. A query about when Xen can support PAT.  In progress; when its
          done, we can remove the unconditional PAT disable.

for-ingo/xen/dom0/pci
for-ingo/xen/dom0/swiotlb

    Updated with Joerg Roedel, FUJITA Tomonori and Matthew Wilcox's
    comments,  Acked-by and Reviewed-bys as appropriate.

for-ingo/xen/dom0/apic-ops

    After discussion between yourself and HPA, we resolved that using
    io_apic_ops was the right way to go forward with this.  I replaced
    for-ingo/xen/dom0/apic with the new branch
    for-ingo/xen/dom0/apic-ops, which is identical aside from
    implementing and using io_apic_ops.

for-ingo/xen/dom0/mtrr

    You queried the value of "extending" this interface, given that its
    considered to be deprecated.  These changes in no way extend the
    interface, but just make the existing interface functional under
    Xen.  And while we don't have PAT support, there's no other way of
    setting cachability attributes on memory, so not supporting it has a
    fairly severe performance impact on things like X.


Aside from some whitespace issues around some Impact: lines, I don't 
know of any outstanding problems.  (I just pushed an updates to these 
branches to fix those, and fold a change to address Jesse's comment.)

Please tell me if you have any further issues which prevents you from 
pulling these changes.  Otherwise I'd appreciate it if you pulled them 
soon, as we're already on -rc5, and I have more changes I'd like to prep 
for the next merge window.

Thanks,
    J
