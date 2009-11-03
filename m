Return-Path: <linux-kernel-owner+w=401wt.eu-S1755081AbZKCJX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081AbZKCJX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 04:23:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753856AbZKCJX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 04:23:56 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33405 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751311AbZKCJXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 04:23:55 -0500
Subject: Re: Kmemleak for mips
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: subscriptions@stroomer.com, linux-mm@kvack.org,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <43e72e890911020907m7cfc48edpd300243de7af36ed@mail.gmail.com>
References: <43e72e890911020907m7cfc48edpd300243de7af36ed@mail.gmail.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Tue, 03 Nov 2009 09:23:47 +0000
Message-Id: <1257240227.22183.3.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Nov 2009 09:23:48.0546 (UTC) FILETIME=[59713A20:01CA5C67]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-02 at 09:07 -0800, Luis R. Rodriguez wrote:
> Curious what the limitations are on restricting kmemleak to non-mips
> archs. I have a user and situation [1] where this could be helpful [1]
> in debugging an issue. The user reports he cannot enable it on mips.

It may just work but cannot be enabled because I cannot test kmemleak on
such hardware. In general you need to make sure that the _sdata/_edata
and __bss_start/__bss_stop symbols are defined. If there are other ways
of allocating memory than the standard API, it would need additional
hooks. Some false-positives specific to MIPS may need to be annotated
(usually with kmemleak_not_leak).

(btw, you could also merge the kmemleak.git tree on git.kernel.org as it
has improvements on the rate of false positives; the patches will be
pushed in 2.6.33-rc1)

-- 
Catalin

