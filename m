Return-Path: <linux-kernel-owner+w=401wt.eu-S1756272AbYCHSh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272AbYCHSh1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 13:37:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753246AbYCHShM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 13:37:12 -0500
Received: from wf-out-1314.google.com ([209.85.200.173]:15206 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837AbYCHShL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 13:37:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Zqfo0j+4ppIMiyNVkX3/+kF5d+IhHiOQFBMUBGvfyFRRMBqL41r7iSHM39EG9tjI3ZjQldJFaFk9r4Gd19H3KZuqzO6WPIDdKtncl8KVEj5dBkLmYV7CCEbI2lxWR4cEEfRE9UZ7sDDf8ynqlVw7yU4xPdOAquXl90b4fDic92E=
Message-ID: <e9e943910803081037w5e7a8743p449b999001b94281@mail.gmail.com>
Date: Sat, 8 Mar 2008 18:37:08 +0000
From: "Duane Griffin" <duaneg@dghda.com>
To: "Christoph Hellwig" <hch@infradead.org>
Subject: Re: [PATCH 2/3] jbd2: replace potentially false assertion with if block
Cc: "Andreas Dilger" <adilger@sun.com>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Theodore Tso" <tytso@mit.edu>,
       sct@redhat.com, akpm@linux-foundation.org
In-Reply-To: <20080308164258.GA30512@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5e28cd633c71f6354a203a43000cbe5fef045589.1204844851.git.duaneg@dghda.com>
	 <48afbb3a44aa24dc1e31835c14e86c3c6c1c3b0a.1204844851.git.duaneg@dghda.com>
	 <20080307212336.GE1881@webber.adilger.int>
	 <20080308150229.GA22430@infradead.org>
	 <e9e943910803080840u251ade36j92612f6150de6cf9@mail.gmail.com>
	 <20080308164258.GA30512@infradead.org>
X-Google-Sender-Auth: 403c88cde7ceb128
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2008, Christoph Hellwig <hch@infradead.org> wrote:
>
> That text above was in reply to Andreas comment about checking it in
>  journal_load.  Your fix obviously does make sense althrough doing it
>  differently as in my reply to your first series would be even better.

Sorry if I'm missing something here, but I think the caches do need to
be checked. If jbd/ext3 are not modular then even if initialisation
fails the journal code may still be called later. I noticed this when
testing the failure modes after making my original fix.

I have some patches ready to go to address this, which I'll send after
this. It turns out journal_load is actually too late to check, though:
journal_init_common is called prior to that and will also blow up if
the caches are uninitialised. I've taken Andreas' suggestion and
attempted to initialise the caches again at that point before failing.

I've modified my changes to match the way you suggested doing things
in your earlier reply (and thanks for the review, BTW). If you would
prefer I'll rework my changes as a separate patch on top. Just let me
know.

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
