Return-Path: <linux-kernel-owner+w=401wt.eu-S1759099AbYJ3VzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759099AbYJ3VzT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 17:55:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbYJ3VzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 17:55:04 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:54219 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbYJ3VzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 17:55:03 -0400
Date: Thu, 30 Oct 2008 14:54:56 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, tim@scalemp.com, shai@scalex86.org
Subject: Re: [patch] x86: Fix /dev/mem mmap breakage when PAT is disabled
Message-ID: <20081030215455.GC6583@localdomain>
References: <20081030020203.GA12423@localdomain> <20081030132103.2daff1e1@infradead.org> <20081030212121.GB6583@localdomain> <20081030142949.75df90cc@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081030142949.75df90cc@infradead.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 02:29:49PM -0700, Arjan van de Ven wrote:
>On Thu, 30 Oct 2008 14:21:21 -0700
>Ravikiran G Thirumalai <kiran@scalex86.org> wrote:
>
>> On Thu, Oct 30, 2008 at 01:21:03PM -0700, Arjan van de Ven wrote:
>> >On Wed, 29 Oct 2008 19:02:03 -0700
>> >Ravikiran G Thirumalai <kiran@scalex86.org> wrote:
>> >
>> >well... technically the aliases are bad without PAT as well...
>> >
>> 
>> Hmm! Well, you mean if mtrr is used to change attributes?
>
>you can also set uncached in the pagetables, like via ioremap_uncached
>and other ways.
>
>and /dev/mem may or may not imply cached/uncached, depending on the
>open flags.
>
>On memory... what would that mean?
>

Well, I am not denying that an incorrectly written userspace program could cause
cache aliasing/crash the system  I am not arguing for or against this
argument at all.

However, there is what seems like an unintended change in behavior from
2.6.25 to 2.6.26 when CONFIG_STRICT_DEVMEM is disabled and PAT is disabled,
which is a bug, and this patch fixes it that's all. If this was intentional,
then I don't see the reason for having CONFIG_STRICT_DEVMEM!!
