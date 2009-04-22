Return-Path: <linux-kernel-owner+w=401wt.eu-S1756047AbZDVQA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047AbZDVQA5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 12:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751933AbZDVQAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 12:00:48 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:60409 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433AbZDVQAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 12:00:47 -0400
From: Stefan Roscher <ossrosch@linux.vnet.ibm.com>
To: michael <michael@evidence.eu.com>
Subject: Re: [PATCH 1/3] IB/ehca: Replace vmalloc with kmalloc
Date: Wed, 22 Apr 2009 18:00:41 +0200
User-Agent: KMail/1.9.9
Cc: Roland Dreier <rdreier@cisco.com>, fenkes@de.ibm.com,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-EWG" <ewg@lists.openfabrics.org>,
       "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>, raisch@de.ibm.com,
       alexschm@de.ibm.com, stefan.roscher@de.ibm.com
References: <200904211716.45245.ossrosch@linux.vnet.ibm.com> <200904221602.29028.ossrosch@linux.vnet.ibm.com> <49EF254A.6020106@evidence.eu.com>
In-Reply-To: <49EF254A.6020106@evidence.eu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904221800.41399.ossrosch@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 April 2009 04:10:18 pm michael wrote:
> Hi,
> 

> I don't take the point, if it is not import use the vmalloc. Why you try 
> with a kmalloc
> alloc first? and why do not use kzalloc?

Because kmalloc() is faster than vmalloc() causing a huge performance win
when someone allocates a large number of queue pairs. We fall back to
vmalloc() only if kmalloc() can't deliver the memory chunk.
We don't need kzalloc because we fill the list right after the alloc.

regards Stefan

