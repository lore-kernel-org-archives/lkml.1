Return-Path: <linux-kernel-owner+w=401wt.eu-S933094AbYETQ6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933094AbYETQ6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 12:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756678AbYETQ61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 12:58:27 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51675 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbYETQ60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 12:58:26 -0400
Date: Tue, 20 May 2008 09:58:10 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: Joel.Becker@oracle.com, Louis.Rilling@kerlabs.com,
       linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [RFC][PATCH 0/3] configfs: Make nested default groups
 lockdep-friendly
Message-ID: <20080520095810.1d50d247@infradead.org>
In-Reply-To: <20080520163320.025971210@kerlabs.com>
References: <20080520163320.025971210@kerlabs.com>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2008 18:33:20 +0200
Louis Rilling <Louis.Rilling@kerlabs.com> wrote:

> Hi all,
> 
> The following patches fix lockdep warnings resulting from (correct)
> recursive locking in configfs.
> 
> Current lockdep annotations for inode mutexes in configfs are
> lockdep-friendly provided that:
> 1/ config_groups have at most one level of default groups (see
>    configfs_attach_group()),
> 2/ config_groups having default groups are never removed (see
>    configfs_detach_prep()).
> 
> Since lockdep does not handle such correct recursion, the idea is to
> insert lockdep_off()/lockdep_on() for inode mutexes as soon as the
> level of recursion of the I_MUTEX_PARENT -> I_MUTEX_CHILD dependency
> pattern increases.

I'm... not entirely happy with such a solution ;(

there must be a better one.
