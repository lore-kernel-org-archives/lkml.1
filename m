Return-Path: <linux-kernel-owner+w=401wt.eu-S1755281AbZBTRxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbZBTRxx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 12:53:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752576AbZBTRxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 12:53:41 -0500
Received: from mail-gx0-f174.google.com ([209.85.217.174]:46914 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbZBTRxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 12:53:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=a20t+mObM7qPbIos8lDyPFP3epAl1autMXj2Ea3Z552vn3aEd0ofaEj8gWE7/eAssc
         OH+xGYZACoYcn17CGePc2WizNNF56l4vMEEYJCwkhvunOvWOwIFGm1AXtLRa9ocvepJt
         PH+PQcxkYY2QQg6QiYV1xlC6uHfJTl6k4U6II=
MIME-Version: 1.0
In-Reply-To: <1234833003-19631-1-git-send-email-bdonlan@gmail.com>
References: <20090214141411.GD26628@mini-me.lan>
	 <1234833003-19631-1-git-send-email-bdonlan@gmail.com>
Date: Fri, 20 Feb 2009 12:53:39 -0500
Message-ID: <3e8340490902200953p704fd9dbuff0a7a890895ea23@mail.gmail.com>
Subject: Re: [PATCH v2] ext[234]: Return -EIO not -ESTALE on directory 
	traversal through deleted inode
From: Bryan Donlan <bdonlan@gmail.com>
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: sct@redhat.com, akpm@linux-foundation.org, adilger@sun.com, tytso@mit.edu,
       Bryan Donlan <bdonlan@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 16, 2009 at 8:10 PM, Bryan Donlan <bdonlan@gmail.com> wrote:

> +               if (unlikely(IS_ERR(inode))) {
> +                       if (PTR_ERR(inode) == -ESTALE) {
> +                               ext3_error(dir->i_sb, "ext2_lookup",
> +                                               "deleted inode referenced: %lu",
> +                                               ino);
> +                               return ERR_PTR(-EIO);
> +                       } else {
> +                               return ERR_CAST(inode);
> +                       }
> +               }

I just noticed that I forgot to edit the function name in the
ext3_error and ext4_error invocations... Would it be better to send a
delta to fix this or resubmit the whole thing?
