Return-Path: <linux-kernel-owner+w=401wt.eu-S1761099AbZAPQJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761099AbZAPQJA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 11:09:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753062AbZAPQIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 11:08:49 -0500
Received: from mx2.redhat.com ([66.187.237.31]:58868 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbZAPQIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 11:08:48 -0500
Message-ID: <4970B0F2.6040507@redhat.com>
Date: Fri, 16 Jan 2009 10:08:18 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (Macintosh/20081209)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Valdis.Kletnieks@vt.edu,
       Pavel Machek <pavel@suse.cz>, Eric Sandeen <sandeen@redhat.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Takashi Sato <t-sato@yk.jp.nec.com>
Subject: Re: [PATCH] Allow SysRq emergency sync to thaw frozen filesystems
References: <496EB639.6090800@redhat.com> <20090116084828.GB4795@atrey.karlin.mff.cuni.cz> <16406.1232119029@turing-police.cc.vt.edu> <20090116154026.GG10683@mit.edu>
In-Reply-To: <20090116154026.GG10683@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Fri, Jan 16, 2009 at 10:17:09AM -0500, Valdis.Kletnieks@vt.edu wrote:
>> On Fri, 16 Jan 2009 09:48:28 +0100, Pavel Machek said:
>>
>>> Emergency Sync should not do this. Invent another key.
>>>
>>> ...because otherwise, if you hit emergency sync but the system is
>>> still alive and relies on filesystem freezing, bad stuff will happen.
>> Under what conditions would a system be alive and relying on freezing,
>> *and* an emergency thaw would be worse than whatever reason you're doing
>> an emergency sync?
>>
>> Hmm.. guess you *could* get into trouble if you tried to do a Sysrq-[not-s]
>> and hit the wrong key - but you have the same danger if you have *any*
>> sysrq- invoking an emergency_thaw and hit it by accident...
> 
> My biggest complaint is that the two operations are largely
> orthogonal.  Emergency sync and unfreeze are two very different
> operations, and while emergency sync is largely harmless, it just
> seems really unclean to combine the two.  For one thing, it'll be
> extremely non-obvious that emergency sync implies unfreeze, and
> changing the sysrq help to say emergency-Sync-and-unfreeze just
> screams "kludge"....
> 
> 						- Ted

Yeah, they really are orthogonal, it's true.  Ok, if people are willing
to give up 'z' I'll move it there.

-Eric
