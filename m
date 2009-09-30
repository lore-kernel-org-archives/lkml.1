Return-Path: <linux-kernel-owner+w=401wt.eu-S1753971AbZI3Bjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971AbZI3Bjn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 21:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753899AbZI3Bjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 21:39:42 -0400
Received: from hosting.visp.net.lb ([194.146.153.11]:43320 "EHLO
	hosting.visp.net.lb" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883AbZI3Bjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 21:39:42 -0400
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Eric.Moore@lsi.com
Subject: MPT Fusion SAS 2.6.31 regression, crash on heavy load
Content-Disposition: inline
From: Denys Fedoryschenko <denys@visp.net.lb>
Organization: VISP
Date: Wed, 30 Sep 2009 04:39:05 +0300
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909300439.05885.denys@visp.net.lb>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most probably this commit fixes my issue. Very strange that this error didn't 
appear before, it seems it exists at 2.6.30 even?

commit	c55b89fba9872ebcd5ac15cdfdad29ffb89329f0

[SCSI] mptsas : PAE Kernel more than 4 GB kernel panic

This patch is solving problem for PAE kernel DMA operation.
On PAE system dma_addr and unsigned long will have different
values.
Now dma_addr is not type casted using unsigned long.

