Return-Path: <linux-kernel-owner+w=401wt.eu-S964950AbYEBRqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964950AbYEBRqP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 13:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757876AbYEBRp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 13:45:58 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:35879 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756817AbYEBRp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 13:45:58 -0400
To: Russ Anderson <rja@sgi.com>
Cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>, Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 3/3] ia64: Call migration code on correctable errors v2
From: Andi Kleen <andi@firstfloor.org>
References: <20080502004425.GD12006@sgi.com>
Date: Fri, 02 May 2008 19:45:55 +0200
In-Reply-To: <20080502004425.GD12006@sgi.com> (Russ Anderson's message of "Thu, 1 May 2008 19:44:25 -0500")
Message-ID: <87fxt0vbu4.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 02 May 2008 17:39:00.0989 (UTC) FILETIME=[683DBAD0:01C8AC7B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russ Anderson <rja@sgi.com> writes:

> Migrate data off pages with correctable memory errors.  This patch is the 
> ia64 specific piece.  It connects the CPE handler to the page migration
> code.  It is implemented as a kernel loadable module, similar to the mca
> recovery code (mca_recovery.ko).  This allows the feature to be turned off
> by uninstalling the module.  Creates /proc/badram to display bad page
> information and free bad pages.

How do you know what pages have excessive errors? And how is excessive defined?
Surely you don't keep  a per page error count? It's unclear from your patch. 

Anyways I don't think this should be ia64 specific, but generic code.

I also have my doubts about making such small code subsystems modules. Modules
always get rounded to pages so it ultimatively just wastes memory.

-Andi
