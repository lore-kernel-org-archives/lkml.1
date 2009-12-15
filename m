Return-Path: <linux-kernel-owner+w=401wt.eu-S1760258AbZLON6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760258AbZLON6U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 08:58:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760237AbZLON6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 08:58:19 -0500
Received: from one.firstfloor.org ([213.235.205.2]:45121 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952AbZLON6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 08:58:18 -0500
To: Zachary Amsden <zamsden@redhat.com>
Cc: kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
       Dor Laor <dlaor@redhat.com>
Subject: Re: [PATCH RFC: kvm tsc virtualization 15/20] Fix longstanding races
From: Andi Kleen <andi@firstfloor.org>
References: <1260850127-9766-1-git-send-email-zamsden@redhat.com>
	<1260850127-9766-2-git-send-email-zamsden@redhat.com>
	<1260850127-9766-3-git-send-email-zamsden@redhat.com>
	<1260850127-9766-4-git-send-email-zamsden@redhat.com>
	<1260850127-9766-5-git-send-email-zamsden@redhat.com>
	<1260850127-9766-6-git-send-email-zamsden@redhat.com>
	<1260850127-9766-7-git-send-email-zamsden@redhat.com>
	<1260850127-9766-8-git-send-email-zamsden@redhat.com>
	<1260850127-9766-9-git-send-email-zamsden@redhat.com>
	<1260850127-9766-10-git-send-email-zamsden@redhat.com>
	<1260850127-9766-11-git-send-email-zamsden@redhat.com>
	<1260850127-9766-12-git-send-email-zamsden@redhat.com>
	<1260850127-9766-13-git-send-email-zamsden@redhat.com>
	<1260850127-9766-14-git-send-email-zamsden@redhat.com>
	<1260850127-9766-15-git-send-email-zamsden@redhat.com>
	<1260850127-9766-16-git-send-email-zamsden@redhat.com>
Date: Tue, 15 Dec 2009 14:58:13 +0100
In-Reply-To: <1260850127-9766-16-git-send-email-zamsden@redhat.com> (Zachary Amsden's message of "Mon, 14 Dec 2009 18:08:42 -1000")
Message-ID: <87ws0owd8q.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden <zamsden@redhat.com> writes:
>
> Damn, this is complicated crap.  The analagous task in real life would
> be keeping a band of howler monkeys, each in their own tree, singing in
> unison while the lead vocalist jumps from tree to tree, and meanwhile,
> an unseen conductor keeps changing the tempo the piece is played at.
> Thankfully, there are no key changes, however, occasionally new trees
> sprout up at random and live ones fall over.

On CPUs where the TSC frequency is not constant typically you can't tell
exactly when the frequency changes. So you would always have a race window
where the frequency is unknown and wrong results occur. This can be worked
around, but it's quite complicated.

The safe way is to not use the TSC on such CPUs.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
