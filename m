Return-Path: <linux-kernel-owner+w=401wt.eu-S1759107AbYB2G6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759107AbYB2G6b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 01:58:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754164AbYB2G6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 01:58:21 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:48930 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753748AbYB2G6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 01:58:20 -0500
Date: Thu, 28 Feb 2008 22:57:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
Cc: hch@infradead.org, viro@ftp.linux.org.uk, trond.myklebust@fys.uio.no,
       bfields@fieldses.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 03/11] VFS: Add security label support to *notify
Message-Id: <20080228225724.cb3938e7.akpm@linux-foundation.org>
In-Reply-To: <1204144786-3502-4-git-send-email-dpquigl@tycho.nsa.gov>
References: <1204144786-3502-1-git-send-email-dpquigl@tycho.nsa.gov>
	<1204144786-3502-4-git-send-email-dpquigl@tycho.nsa.gov>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008 15:39:38 -0500 "David P. Quigley" <dpquigl@tycho.nsa.gov> wrote:

> +#ifdef CONFIG_SECURITY
> +	if (ia_valid & ATTR_SECURITY_LABEL) {
> +		char *key = (char *)security_maclabel_getname();
> +		vfs_setxattr_locked(dentry, key,
> +			attr->ia_label, attr->ia_label_len, 0);

It would be nicer to change vfs_setxattr_locked() so that it
takes a const char *.
