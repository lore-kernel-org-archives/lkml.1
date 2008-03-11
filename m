Return-Path: <linux-kernel-owner+w=401wt.eu-S1751508AbYCKWs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508AbYCKWs7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 18:48:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750874AbYCKWsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 18:48:52 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:56662 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbYCKWsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 18:48:51 -0400
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@osdl.org, wli@holomorphy.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Terminate hugetlbfs mount argument list
X-Message-Flag: Warning: May contain useful information
References: <20080311224204.GA16719@basil.nowhere.org>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 11 Mar 2008 15:48:46 -0700
In-Reply-To: <20080311224204.GA16719@basil.nowhere.org> (Andi Kleen's message of "Tue, 11 Mar 2008 23:42:04 +0100")
Message-ID: <adabq5klvw1.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 11 Mar 2008 22:48:47.0315 (UTC) FILETIME=[11130230:01C883CA]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > The match_table_t for the mount arguments in hugetlbfs wasn't 
 > terminated as match_tokens expect. I didn't see a crash just code
 > audit, but it's still safer to terminate it in case the variables after
 > that in .data are not NULL.

I think you're misunderstanding the match_token() interface.  The
comment before match_token() says:

 * @table: match_table_t describing the set of allowed option tokens and the
 * arguments that may be associated with them. Must be terminated with a
 * &struct match_token whose pattern is set to the NULL pointer.

and that's exactly what already exists here:

 	{Opt_gid,	"gid=%u"},
 	{Opt_err,	NULL},

So your patch is effectively an obfuscated NOP.

 - R.
