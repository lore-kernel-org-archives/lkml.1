Return-Path: <linux-kernel-owner+w=401wt.eu-S1761581AbYEETNO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761581AbYEETNO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 15:13:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbYEETM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 15:12:58 -0400
Received: from relay1.sgi.com ([192.48.171.29]:55173 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750885AbYEETM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 15:12:56 -0400
Date: Mon, 5 May 2008 12:12:56 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mike Travis <travis@sgi.com>
cc: arges@linux.vnet.ibm.com, phil.el@wanadoo.fr, mpjohn@us.ibm.com,
       Jack Steiner <steiner@sgi.com>, Paul Jackson <pj@sgi.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Hotplug CPU support for Oprofile
In-Reply-To: <481F5965.6070305@sgi.com>
Message-ID: <Pine.LNX.4.64.0805051211110.11469@schroedinger.engr.sgi.com>
References: <1210012443.6374.23.camel@snuffleupagus> <481F5965.6070305@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The allocpercpu approach creates a pointer array and results in objects 
distributed over all of memory. A cpu alloc approach would place 
dynamically allocated per cpu objects together which is better for memory 
consumption (no need to align) and performance (same TLB entry, neigboring 
memory cells, possible shared cachelines).

