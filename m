Return-Path: <linux-kernel-owner+w=401wt.eu-S1754558AbYJ2SAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbYJ2SAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 14:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbYJ2SAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 14:00:41 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:40021 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186AbYJ2SAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 14:00:41 -0400
Message-ID: <4908A4CC.3000300@austin.ibm.com>
Date: Wed, 29 Oct 2008 13:00:44 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: gerald.schaefer@de.ibm.com
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       kamezawa.hiroyu@jp.fujitsu.com, y-goto@jp.fujitsu.com,
       dave@linux.vnet.ibm.com
Subject: Re: [PATCH] memory hotplug: fix page_zone() calculation in	test_pages_isolated()
References: <1225290330.10021.7.camel@t60p>
In-Reply-To: <1225290330.10021.7.camel@t60p>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like you beat me to it, and with a nicer fix too.

Gerald Schaefer wrote:
> From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
> 
> My last bugfix here (adding zone->lock) introduced a new problem: Using
> page_zone(pfn_to_page(pfn)) to get the zone after the for() loop is wrong.
> pfn will then be >= end_pfn, which may be in a different zone or not
> present at all. This may lead to an addressing exception in page_zone()
> or spin_lock_irqsave().
> 
> Now I use __first_valid_page() again after the loop to find a valid page
> for page_zone().
> 
> Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>

Acked-by: Nathan Fontenot <nfont@austin.ibm.com>
