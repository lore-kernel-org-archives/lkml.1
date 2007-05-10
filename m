Return-Path: <linux-kernel-owner+w=401wt.eu-S1761745AbXEJLps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761745AbXEJLps (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 07:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761463AbXEJLmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 07:42:40 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:26439 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755024AbXEJLmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 07:42:38 -0400
X-IronPort-AV: i="4.14,517,1170662400"; 
   d="scan'208"; a="420551336:sNHT43097962"
To: Paul Mundt <lethal@linux-sh.org>
Cc: Roland Dreier <rolandd@cisco.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: trivial MLX4_DEBUG dependency fix.
X-Message-Flag: Warning: May contain useful information
References: <20070510035028.GA26453@linux-sh.org>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 10 May 2007 04:42:37 -0700
In-Reply-To: <20070510035028.GA26453@linux-sh.org> (Paul Mundt's message of "Thu, 10 May 2007 12:50:28 +0900")
Message-ID: <aday7jw29ci.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 10 May 2007 11:42:37.0708 (UTC) FILETIME=[4EED7CC0:01C792F8]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > CONFIG_MLX4_DEBUG works out to a def_bool y for those that
 > have CONFIG_EMBEDDED set. Make it depend on MLX4_CORE..

Thanks, applied...  (by the way, this bug just results in an
extraneous CONFIG variable being defined, right?  There's no further
breakage -- or am I misunderstanding the situation?)

 > I'll let someone else wonder why debugging output is default enabled,
 > this seems to be a worrying trend as of late.

Actually this option just controls whether to build the debugging
output at all.  The output is controlled at runtime with a module
parameter (which can be changed via sysfs after the module is loaded),
and the output defaults to off.

The reason why I want building the debugging stuff to default to y is
so that distros automatically build modules with debugging enabled.
Otherwise it's a pain to try and gather info from someone who has
problems with a kernel they didn't build.

Thanks,
  Roland
