Return-Path: <linux-kernel-owner+w=401wt.eu-S1759639AbXK0VYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759639AbXK0VYp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 16:24:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757012AbXK0VYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 16:24:36 -0500
Received: from mx1.suse.de ([195.135.220.2]:53172 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755415AbXK0VYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 16:24:35 -0500
From: Andreas Schwab <schwab@suse.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org, tony.luck@intel.com
Subject: Re: [patch 04/14] ia64: Remove the __SMALL_ADDR_AREA attribute for per cpu access
References: <20071127001407.859743255@sgi.com>
	<20071127001430.083503280@sgi.com> <jehcj83uir.fsf@sykes.suse.de>
	<Pine.LNX.4.64.0711271016500.2310@schroedinger.engr.sgi.com>
X-Yow: There's a lot of BIG MONEY in MISERY if you have an AGENT!!
Date: Tue, 27 Nov 2007 22:24:33 +0100
In-Reply-To: <Pine.LNX.4.64.0711271016500.2310@schroedinger.engr.sgi.com>
	(Christoph Lameter's message of "Tue\, 27 Nov 2007 10\:17\:14 -0800
	\(PST\)")
Message-ID: <jeabozs7ou.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter <clameter@sgi.com> writes:

> On Tue, 27 Nov 2007, Andreas Schwab wrote:
>
>> Christoph Lameter <clameter@sgi.com> writes:
>> 
>> > The model(small) attribute is not supported by gcc 4.X.
>> 
>> Which gcc 4.X are you talking about?
>
> All. Last gcc that supported this was 3.4.

Strange.  Works fine here.

$ arch/ia64/scripts/toolchain-flags gcc objdump readelf
-DHAVE_WORKING_TEXT_ALIGN -DHAVE_MODEL_SMALL_ATTRIBUTE -DHAVE_SERIALIZE_DIRECTIVE
$ gcc --version | head -n 1
gcc (GCC) 4.2.1 (SUSE Linux)
$ grep ia64_handle_model_attribute config/ia64/*.c
config/ia64/ia64.c:static tree ia64_handle_model_attribute (tree *, tree, tree, int, bool *);
config/ia64/ia64.c:  { "model",	       1, 1, true, false, false, ia64_handle_model_attribute },
config/ia64/ia64.c:ia64_handle_model_attribute (tree *node, tree name, tree args,
$ grep small_addr_symbolic_operand config/ia64/*.md
config/ia64/constraints.md:  (match_operand 0 "small_addr_symbolic_operand"))
config/ia64/predicates.md:(define_predicate "small_addr_symbolic_operand" 

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
