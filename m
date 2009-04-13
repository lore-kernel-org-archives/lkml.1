Return-Path: <linux-kernel-owner+w=401wt.eu-S1755046AbZDMLQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046AbZDMLQq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 07:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753241AbZDMLQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 07:16:37 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:57022 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752938AbZDMLQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 07:16:37 -0400
Subject: Re: [PATCH 00/30] C/R OpenVZ/Virtuozzo style
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: xemul@parallels.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, hch@infradead.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org, mingo@elte.hu
In-Reply-To: <20090413091423.GA19236@x200.localdomain>
References: <20090410023207.GA27788@x200.localdomain>
	 <1239340031.24083.21.camel@nimitz>
	 <20090413091423.GA19236@x200.localdomain>
Content-Type: text/plain
Date: Mon, 13 Apr 2009 04:16:32 -0700
Message-Id: <1239621392.32604.22.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-13 at 13:14 +0400, Alexey Dobriyan wrote:
> [1] Do I inderstand correctly that cookie for shared object is an
> address on kernel stack? This is obviously unreliable, if yes :-)
> 
>         int objref;
>                 ...
>         /* adding 'file' to the hash will keep a reference to it */
>         new = cr_obj_add_ptr(ctx, file, &objref, CR_OBJ_FILE, 0);

No, that's just Oren's way to get two return variables.

He needs 'new' to figure out whether to write out the full file or just
an objref record.  He also needs 'objref' itself in case of writing
either.  cr_obj_add_ptr() modifies objref.

-- Dave

