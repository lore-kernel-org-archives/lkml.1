Return-Path: <linux-kernel-owner+w=401wt.eu-S932626AbZJAOUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932626AbZJAOUH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 10:20:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932427AbZJAOUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 10:20:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:53186 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932423AbZJAOUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 10:20:05 -0400
Subject: Re: [PATCH 02/34] move atp870u_remove to .devexit.text
From: James Bottomley <James.Bottomley@suse.de>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Yang Hongyang <yanghy@cn.fujitsu.com>, Alan Cox <alan@redhat.com>,
       linux-scsi@vger.kernel.org
In-Reply-To: <1254385718-14254-2-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20091001082607.GA2181@pengutronix.de>
	 <1254385718-14254-2-git-send-email-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Oct 2009 14:20:02 +0000
Message-Id: <1254406802.3885.1.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-01 at 10:28 +0200, Uwe Kleine-König wrote:
> The function atp870u_remove is used only wrapped by __devexit_p so define
> it using __devexit.

What's the justification for this?

Given that practically every kernel on the planet is hotplug enabled
these days and that the savings on the very few that aren't from
discarding the devexit section is at most a page or two (and even arm
says they don't care about that), there doesn't seem to be any point
making these changes.  In fact, I think we can just kill devinit and
devexit as section markers.

James


