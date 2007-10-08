Return-Path: <linux-kernel-owner+w=401wt.eu-S1754745AbXJHWub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbXJHWub (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 18:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752034AbXJHWuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 18:50:22 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:30034 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbXJHWuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 18:50:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=uneTD74F1kzYMdN0YaFILJSMUNDRMc/0zwIBV+VAaMQVqmiOS5dwBkd/Ie0aQBrWrko/kvwLCuDe+WCjQgmXYdCC8DKlLwCZjvdYt4HuR5rh+bMNMGsBA9sO5eL2AjR/RhtEatBiHJ8gjSbK39xRx5ulAJpVbTIQrQZmDSR906c=
Message-ID: <3d0408630710081550k430f50c1nae5097776358f1a0@mail.gmail.com>
Date: Tue, 9 Oct 2007 06:50:17 +0800
From: "Yan Zheng" <yanzheng@21cn.com>
To: "Hugh Dickins" <hugh@veritas.com>
Subject: Re: [PATCH]fix VM_CAN_NONLINEAR check in sys_remap_file_pages
Cc: "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Miklos Szeredi" <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <Pine.LNX.4.64.0710081418140.8640@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3d0408630710080445j4dea115emdfe29aac26814536@mail.gmail.com>
	 <Pine.LNX.4.64.0710081418140.8640@blonde.wat.veritas.com>
X-Google-Sender-Auth: 099984a27680e61d
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/10/8, Hugh Dickins <hugh@veritas.com>:
> On Mon, 8 Oct 2007, Yan Zheng wrote:
> >
> > The test for VM_CAN_NONLINEAR always fails
> Good catch indeed.  Though I was puzzled how we do nonlinear at all,
> until I realized it's "The test for not VM_CAN_NONLINEAR always fails".
> It's not as serious as it appears, since code further down has been
> added more recently to simulate nonlinear on non-RAM-backed filesystems,
> instead of going the real nonlinear way; so most filesystems are now not
> required to do what VM_CAN_NONLINEAR was put in to ensure they could do.
> I'm confused as to where that leaves us: is this actually a fix that
> needs to go into 2.6.23?  or will it suddenly disable a system call
> which has been silently working fine on various filesystems which did
> not add VM_CAN_NONLINEAR?  could we just rip out VM_CAN_NONLINEAR?
> I hope Nick or Miklos is clearer on what the risks are.
> (Apologies for all the "not"s and "non"s here, I'm embarrassed
> after just criticizing Ingo's SCHED_NO_NO_OMIT_FRAME_POINTER!)
> Hugh

Yes, I mean "The test for not VM_CAN_NONLINEAR always fails".  please
forgive my poor English.
