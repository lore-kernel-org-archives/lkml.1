Return-Path: <linux-kernel-owner+w=401wt.eu-S934528AbZLPXmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934528AbZLPXmZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 18:42:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933841AbZLPXmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 18:42:22 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:37395 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933853AbZLPXmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 18:42:21 -0500
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEANr+KEurRN+J/2dsb2JhbAC+H5cHhCsE
X-IronPort-AV: E=Sophos;i="4.47,409,1257120000"; 
   d="scan'208";a="120950026"
From: Roland Dreier <rdreier@cisco.com>
To: Simon Horman <horms@verge.net.au>
Cc: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
       kexec@lists.infradead.org
Subject: Re: kexec reboot broken with ioatdma?
References: <ada3a3a8v1g.fsf@roland-alpha.cisco.com>
	<20091216224912.GC16219@verge.net.au>
	<aday6l27c7w.fsf@roland-alpha.cisco.com>
	<20091216233613.GA22449@verge.net.au>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 16 Dec 2009 15:42:20 -0800
In-Reply-To: <20091216233613.GA22449@verge.net.au> (Simon Horman's message of
	"Thu, 17 Dec 2009 10:36:13 +1100")
Message-ID: <adapr6e7ag3.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 16 Dec 2009 23:42:20.0901 (UTC) FILETIME=[68F61150:01CA7EA9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > If its reset in a standard path, then yes that seems sensible to me.
 > I'm mainly concerned about avoiding something along the lines of:
 > 
 > 	if (is_booting_from_kexec)
 > 		reset_hw();

I think we all agree... the idea is to change from

	init_hw()
	{
		/* assume hw is in pristine state */
		do_init();
	}

to

	init_hw()
	{
		/* hw is in unknown state */
		reset_hw();
		do_init();
	}

 - R.
