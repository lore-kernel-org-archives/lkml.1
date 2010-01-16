Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab0APMRK (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 07:17:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752380Ab0APMRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 07:17:09 -0500
Received: from isilmar.linta.de ([213.133.102.198]:39525 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751981Ab0APMRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 07:17:06 -0500
Date: Sat, 16 Jan 2010 13:04:10 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-pcmcia@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: broken pcmcia_bus_match for dynids
Message-ID: <20100116120410.GB20984@comet.dominikbrodowski.net>
Mail-Followup-To: Jiri Slaby <jirislaby@gmail.com>,
	linux-pcmcia@lists.infradead.org,
	LKML <linux-kernel@vger.kernel.org>
References: <4B4DBF9D.7040002@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B4DBF9D.7040002@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Wed, Jan 13, 2010 at 01:42:05PM +0100, Jiri Slaby wrote:
> stanse found that when PCMCIA_DEV_ID_MATCH_FAKE_CIS is set in
> match_flags for a dynid, the pcmcia layer may deadlock.
> 
> pcmcia_load_firmware in such case calls non-atomic operations
> (request_firmware, kzalloc(GFP_KERNEL)), while dynids.lock spinlock is held.
> 
> Any ideas how to solve this? Any idea, why p_drv->dynids.lock is not a
> mutex instead?

Well, as dynid->id.cisfile is never set, it is still NULL, which means
pcmcia_load_firmware is left immediately, without calling the (blocking)
request_firmare(). So this actually isn't a problem, AFAICS.

Nonetheless, I'll prepare a patch to replace it with a mutex for 2.6.34.

Best,
	Dominik
