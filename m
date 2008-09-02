Return-Path: <linux-kernel-owner+w=401wt.eu-S1754189AbYIBR3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbYIBR3V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 13:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbYIBR3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 13:29:13 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:52320 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825AbYIBR3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 13:29:12 -0400
Subject: Re: [PATCH] hugepage: support ZERO_PAGE()
From: Adam Litke <agl@us.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hugh@veritas.com>,
       Kawai Hidehiro <hidehiro.kawai.ez@hitachi.com>,
       William Irwin <wli@holomorphy.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <20080902100910.1AAB.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080829082832.3C1D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <1220023713.14358.173.camel@localhost.localdomain>
	 <20080902100910.1AAB.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain
Organization: IBM
Date: Tue, 02 Sep 2008 12:27:48 -0500
Message-Id: <1220376468.31378.25.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-02 at 10:21 +0900, KOSAKI Motohiro wrote:
> +static int huge_zeropage_ok(pte_t *ptep, int write, int shared)
> +{
> +	if (!ptep)
> +		return 0;
> +
> +	if (write)
> +		return 0;
> +
> +	if (shared)
> +		return 0;
> +
> +	return huge_pte_none(huge_ptep_get(ptep));
> +}

In addition to the comments from Mel, I'd like to see this function
collapsed a bit...

if (!ptep || write || shared)
	return 0;
else
	return huge_pte_none(huge_ptep_get(ptep));

-- 
Adam Litke - (agl at us.ibm.com)
IBM Linux Technology Center

