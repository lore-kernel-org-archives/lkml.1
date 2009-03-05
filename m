Return-Path: <linux-kernel-owner+w=401wt.eu-S1756585AbZCEQvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585AbZCEQvQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 11:51:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754706AbZCEQu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 11:50:58 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:64007 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbZCEQu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 11:50:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=F1gwWVuAR/ww6syGyEv4IKd3stfkaSC4SChEaUvQkPSykLBR9mMCCQzf5zDa3BDOZb
         1YH/I96OptjPofms1/AfAbMjo91FsomAEfEYvsldyvtEZqzE1HOcs70ERx0OCCmK7goL
         mO750wVr66l2mJb9LQf4j8kUgSE9csvszX32o=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH 3/3] ide-{cd,floppy}: do not map all cmds to an sg
Date: Thu, 5 Mar 2009 17:52:41 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc6-next-20090304; KDE/4.2.0; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1236158216-23052-1-git-send-email-petkovbb@gmail.com> <200903051549.22518.bzolnier@gmail.com> <9ea470500903050719m7952f84ct56475c6445846eeb@mail.gmail.com>
In-Reply-To: <9ea470500903050719m7952f84ct56475c6445846eeb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903051752.41611.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 March 2009, Borislav Petkov wrote:
> Hi,
> 
> > Unrelated to the original issue that the patch tries to fix
> > (sg mapping no data commands which OOPS-es w/ DEBUG_VIRTUAL=y):
> > - moving ide_init_sg_cmd()+ide_map_sg() to ide_issue_pc()
> > - converting the code to use blk_rq_bytes()
> 
> aah, ok, now I could get exactly what you meant :). However, (!) ide-floppy is
> potentially broken in the same way for data-less cmds since we unconditionally

Indeed, you are right but it seems that this is not a new problem.

Wait... it makes things "worse" as there should have been 3 patches:
(IOW _three_ patchpoints! ;):

- ide-cd fix for problematic patch
- ide-floppy fix for mainline
- ide-atapi cleanup for pata tree

Thanks,
Bart
