Return-Path: <linux-kernel-owner+w=401wt.eu-S1755403AbYCHQk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403AbYCHQk7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 11:40:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753246AbYCHQku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 11:40:50 -0500
Received: from wf-out-1314.google.com ([209.85.200.168]:15995 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbYCHQkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 11:40:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=R2rcBvZnCldyQmb6PcNfKmL/RdK27297D9PYa/Q8T7Rpls+cot86v0tlfaw+7/YJ02hmdbQViwhPhYxhXp/ChwP+URCCtm40TDrCPhsTMYjsnt0QXKkidADUE+dqLxsq9pOpsai2I8+i84qc0Zn4z3KiSaZ0DRaEETqJx475WUk=
Message-ID: <e9e943910803080840u251ade36j92612f6150de6cf9@mail.gmail.com>
Date: Sat, 8 Mar 2008 16:40:46 +0000
From: "Duane Griffin" <duaneg@dghda.com>
To: "Christoph Hellwig" <hch@infradead.org>
Subject: Re: [PATCH 2/3] jbd2: replace potentially false assertion with if block
Cc: "Andreas Dilger" <adilger@sun.com>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Theodore Tso" <tytso@mit.edu>,
       sct@redhat.com, akpm@linux-foundation.org
In-Reply-To: <20080308150229.GA22430@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5e28cd633c71f6354a203a43000cbe5fef045589.1204844851.git.duaneg@dghda.com>
	 <48afbb3a44aa24dc1e31835c14e86c3c6c1c3b0a.1204844851.git.duaneg@dghda.com>
	 <20080307212336.GE1881@webber.adilger.int>
	 <20080308150229.GA22430@infradead.org>
X-Google-Sender-Auth: 365233060d01b8cc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2008, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Mar 07, 2008 at 02:23:36PM -0700, Andreas Dilger wrote:
>
> > It would probably be prudent to verify that these caches are initialized
>  > at journal_load() time and either re-try to create the cache, and/or report
>  > an error in that case and refuse to continue mounting.
>
> That doesn't make any sense.  They're initialized in module_init and
>  destoryed in module_exit.  They can never be zero at journal_load time
>  unless you get random memory corruption overwriting exactly that pointer
>  with zero.

If jbd is a module, sure, but not if it is statically linked in. I
have the stacktraces to prove it :)

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
