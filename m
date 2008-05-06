Return-Path: <linux-kernel-owner+w=401wt.eu-S1761456AbYEFMfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761456AbYEFMfp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 08:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754193AbYEFMfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 08:35:33 -0400
Received: from mail.issp.bas.bg ([195.96.236.10]:41743 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754133AbYEFMfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 08:35:32 -0400
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: linux-kernel@vger.kernel.org
Subject: CONFIG_HIGHMEM or CONFIG_HIGHMEM64G in illegal_highdma()
Date: Tue, 6 May 2008 15:35:40 +0300
User-Agent: KMail/1.9.7
Cc: netdev@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805061535.40424.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

The usage of NETIF_F_HIGHDMA in net drivers make me think its 
purpose is to declare drivers's capability to address RAM above 4GB, OK?

For x86_64 CONFIG_HIGHMEM is not defined, so the function 
illegal_highdma() found in net/core/dev.c returns 0 because 
x86_64 has IOMMU mapping all RAM.

For x86_32 CONFIG_HIGHMEM is defined as 
(CONFIG_HIGHMEM4G || CONFIG_HIGHMEM64G)
While CONFIG_HIGHMEM4G insures RAM is bellow 4GB some checks
are unnecessarily done. 

Should we have CONFIG_HIGHMEM64G in illegal_highdma()
instead of CONFIG_HIGHMEM?

Regards.

Marin Mitov
