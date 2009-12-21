Return-Path: <linux-kernel-owner+w=401wt.eu-S1751904AbZLUHX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904AbZLUHX2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 02:23:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751564AbZLUHX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 02:23:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:56920 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069AbZLUHX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 02:23:26 -0500
Message-ID: <4B2F2305.8030001@kernel.org>
Date: Mon, 21 Dec 2009 16:25:57 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [this_cpu_xx V8 09/16] Allow arch to provide inc/dec functionality
 for each size separately
References: <20091218222617.384355422@quilx.com> <20091218222652.446462888@quilx.com>
In-Reply-To: <20091218222652.446462888@quilx.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2009 07:26 AM, Christoph Lameter wrote:
> Current this_cpu ops only allow an arch to specify add RMW operations or inc
> and dec for all sizes. Some arches can do more efficient inc and dec
> operations. Allow size specific override of fallback functions like with
> the other operations.

Wouldn't it be better to use __builtin_constant_p() and switching in
arch add/dec macros?  It just seems a bit extreme to define all those
different variants from generic header.  I'm quite unsure whether
providing overrides for all the different size variants from generic
header is necessary at all.  If an arch is gonna override the
operation, it's probably best to just let it override the whole thing.

Thanks.

-- 
tejun
