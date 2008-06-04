Return-Path: <linux-kernel-owner+w=401wt.eu-S1758712AbYFDInY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758712AbYFDInY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 04:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbYFDInO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 04:43:14 -0400
Received: from qb-out-0506.google.com ([72.14.204.224]:33555 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbYFDInN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 04:43:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EuWRWZ11Qmq0na6GoEW001bY2+UTrLbQkDn4+DP6fnpBn+n9AARUVDgh2Y7qWI3joE0MSPjodJ9/517zsrnqQ9o1Jw6Kl7aFA8aFeAsd5N2I5vydUpnYAYkTN/VheDQ78e47poIbGlkwBFDZrOgcVrZXIiEdtXOUBLxVv/vC9JA=
Message-ID: <cfd18e0f0806040143x6343194bl2b7b0111cc84375f@mail.gmail.com>
Date: Wed, 4 Jun 2008 10:43:12 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Miklos Szeredi" <miklos@szeredi.hu>
Subject: Re: [parch 4/4] vfs: utimensat(): fix write access check for futimens()
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, hch@lst.de,
       viro@zeniv.linux.org.uk, jamie@shareable.org, drepper@redhat.com,
       linux-fsdevel@vger.kernel.org, subrata@linux.vnet.ibm.com
In-Reply-To: <E1K3lxO-0007t2-2d@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4845C4D2.8050408@gmail.com>
	 <E1K3kot-0007gz-U7@pomaz-ex.szeredi.hu>
	 <E1K3lxO-0007t2-2d@pomaz-ex.szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 4, 2008 at 7:54 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> At which point the "if (f)" and the "else" branches become equivalent
>> (the nameidata isn't interesting in the other case either).  So that
>> could be written as:
>>
>>               if (!is_owner_or_cap(inode)) {
>>                       error = permission(inode, MAY_WRITE, NULL);
>>                       if (error)
>>                               goto mnt_drop_write_and_out;
>>               }
>
> And also the IS_IMMUTABLE() check can be removed, since it's checked
> by permission(MAY_WRITE) anyway.

I'm not sure that that is true, because immutability applies
regardless of capabilities or ownership, right?

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
