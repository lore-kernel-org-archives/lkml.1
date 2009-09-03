Return-Path: <linux-kernel-owner+w=401wt.eu-S1756047AbZICRKC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047AbZICRKC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 13:10:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756031AbZICRKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 13:10:00 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:49147 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011AbZICRJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 13:09:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MY0Xh4YUnYSZlrv5gOvmBJXfVYulBHpv3pOKnLepr3rRtWIbg9ttuVNpjrDB6sH8IR
         9hs2f98gACeMXVLQ0xisAPNknOfKdtBSjujPhdcYIebtXPm9DbgDfqaK2M8Q64/tBO06
         SaDKDTZPIrlwyRuO2gOYvSDIyvOJF+ImbU8a4=
Date: Thu, 3 Sep 2009 21:09:58 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>,
       Roland McGrath <roland@redhat.com>, Tom Horsley <tom.horsley@att.net>,
       linux-kernel@vger.kernel.org
Subject: Re: binfmt_flat.c && bprm->cred (Was: [PATCH 0/1] exec: do not
	sleep in TASK_TRACED under ->cred_guard_mutex)
Message-ID: <20090903170958.GE5485@lenovo>
References: <20090903160510.GA23638@redhat.com> <20090903162939.GA24528@redhat.com> <20090903165850.GC5485@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090903165850.GC5485@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Thu, Sep 03, 2009 at 08:58:50PM +0400]
...
| ...  
| | -static int load_flat_shared_library(int id, struct lib_info *libs)
| | +static int load_flat_shared_library(struct linux_binprm *bprm, int id,
| | +						struct lib_info *libs)
| |  {
| ...
| | +	sprintf(buf, "/lib/lib%d.so", id);
| 
| Hi Oleg, perhaps it is a good moment to switch sprintf to snprintf
| as well? buf is only 16 bytes long so we have 4 byte room for number.
| Not sure if it's possible to have 10000 relocs though :) Just a thought.
| Most probably I miss something.
| 
| 	-- Cyrill

Sigh... I'm idiot. We have MAX_SHARED_LIBS limit here. Drop my question
please. Sorry for noise.

	-- Cyrill
