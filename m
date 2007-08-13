Return-Path: <linux-kernel-owner+w=401wt.eu-S973061AbXHMN2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S973061AbXHMN2u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 09:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968732AbXHMJ1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 05:27:47 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:38289 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968193AbXHMJ1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 05:27:45 -0400
Message-ID: <46C02274.7060600@linux.vnet.ibm.com>
Date: Mon, 13 Aug 2007 14:50:52 +0530
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH] ext3: fix ext34_fill_super group description initialization
References: <20070813090954.GA25226@dnb.sw.ru>
In-Reply-To: <20070813090954.GA25226@dnb.sw.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Dmitry Monakhov wrote:
> ->s_group_desc have to be zero filled because if sb_read() failed
> we jump to following error path.
> failed_mount2:
> 	for (i = 0; i < db_count; i++)
> 		brelse(sbi->s_group_desc[i]);<< Bad things may happen here
> 


But the db_count is updated in the failure path to point to the number
of successful sb_read. 

-aneesh
