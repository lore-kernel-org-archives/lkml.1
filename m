Return-Path: <linux-kernel-owner+w=401wt.eu-S1758092AbYHEROj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092AbYHEROj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 13:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760157AbYHEROb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 13:14:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54035 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760119AbYHEROa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 13:14:30 -0400
Message-ID: <489888FB.9060401@linux-foundation.org>
Date: Tue, 05 Aug 2008 12:08:11 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Yasunori Goto <y-goto@jp.fujitsu.com>,
       Badari Pulavarty <pbadari@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-mm <linux-mm@kvack.org>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC:Patch: 000/008](memory hotplug) rough idea of pgdat removing
References: <20080802090335.D6C8.E1E9C6FF@jp.fujitsu.com> <4897032E.5020601@linux-foundation.org> <20080805150434.BF32.E1E9C6FF@jp.fujitsu.com> <20080805111450.GE20243@csn.ul.ie>
In-Reply-To: <20080805111450.GE20243@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:

> Maybe I am missing something, but what is wrong with stop_machine during
> memory hot-remove?

Reclaim can sleep while going down a zonelist. There would need to be some
form of synchronization to avoid removing a zone from the zonelist that we are
just scanning.
