Return-Path: <linux-kernel-owner+w=401wt.eu-S1755521AbYLDMtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbYLDMtB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 07:49:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbYLDMsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 07:48:50 -0500
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:34118 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbYLDMst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 07:48:49 -0500
Date: Thu, 4 Dec 2008 13:48:45 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Jason Baron <jbaron@redhat.com>
Cc: Greg K-H <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] DEBUG_KOBJECT vs. DYNAMIC_PRINTK_DEBUG
Message-ID: <20081204134845.6c1df66b@gondolin>
In-Reply-To: <20081203201203.GA3128@redhat.com>
References: <20081202145251.6555d4cc@gondolin>
	<20081203201203.GA3128@redhat.com>
Organization: IBM Deutschland Research & Development GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Erich
 Baier Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Dec 2008 15:12:03 -0500,
Jason Baron <jbaron@redhat.com> wrote:

> indeed. you raise the more general question of what do if both 'DEBUG'
> and 'CONFIG_DYNAMIC_PRINTK_DEBUG' are set for a file? I think that in
> general the 'DEBUG' should take precedence, as you point out. However, I
> think we should fix this by reshuffling the logic in
> include/linux/kernel.h by doing:
> 
> if (DEBUG)
> 	#define pr_debug printk
> elseif (CONFIG_DYNAMIC_PRINTK_DEBUG)
> 	#define pr_debug dynamic_pr_debug()
> else
> 	#define pr_debug if (0) blah:
> endif
> 
> make sense? what do you think?

Yes, that makes sense, I agree. I'll follow up with a patch.
