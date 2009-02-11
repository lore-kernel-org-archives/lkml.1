Return-Path: <linux-kernel-owner+w=401wt.eu-S1757852AbZBKSMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757852AbZBKSMW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 13:12:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755325AbZBKSMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 13:12:13 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:28183 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755061AbZBKSML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 13:12:11 -0500
X-IronPort-AV: E=Sophos;i="4.38,193,1233532800"; 
   d="scan'208";a="63040078"
From: Roland Dreier <rdreier@cisco.com>
To: Steve Wise <swise@opengridcomputing.com>
Cc: randy.dunlap@oracle.com, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] [PATCH 2.6.30] RDMA/cxgb3: Remove modulo math.
References: <20090210184448.22891.31130.stgit@dell3.ogc.int>
	<adamyctajv8.fsf@cisco.com> <4992F26A.4030800@opengridcomputing.com>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 11 Feb 2009 10:12:09 -0800
In-Reply-To: <4992F26A.4030800@opengridcomputing.com> (Steve Wise's message of
	"Wed, 11 Feb 2009 09:44:42 -0600")
Message-ID: <adatz70972e.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 11 Feb 2009 18:12:10.0247 (UTC) FILETIME=[41A92970:01C98C74]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Note that wr->sg_list[i].addr was being cast to a u32.  That was wrong.

Is it possible for the page to be bigger than 4GB?  If so then yes you
might be chopping off high-order bits or something.

Anyway please send me this change as a separate patch with a changelog
explaining that you're avoiding the div etc.... I don't want to roll it
in with the other unrelated fix (which changes code that was never
upstream anyway).
