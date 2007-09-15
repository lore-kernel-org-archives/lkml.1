Return-Path: <linux-kernel-owner+w=401wt.eu-S1752709AbXIOPv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709AbXIOPv5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 11:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755908AbXIOPvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 11:51:45 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:21371 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755884AbXIOPvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 11:51:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZjBN7rj0sYxDL2UjHkSA+lC3f6MvCatbvC3w5P7yXKX4fgjwVWYMmR8joagu5zufnZsB+YomksVRz4GN7I4+VlPyiLyHFP0+Wyqzh6X7XQHBcpfYRcdl618k4le0HQcC7HXdCbQiyWpkfhlei7BhsvQtbJILK8GZzhgwIB3+uRw=
Message-ID: <a36005b50709150851s52d04554t62d53dab3f47eaf8@mail.gmail.com>
Date: Sat, 15 Sep 2007 08:51:39 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "David Howells" <dhowells@redhat.com>
Subject: Re: Credentials test patch
Cc: viro@ftp.linux.org.uk, hch@infradead.org, torvalds@osdl.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1577.1189713412@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1577.1189713412@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In sys_faccessat you temporarily allocate a cred object which is
discarded in the end.  With a few more macro definitions you could
create a dup_cred variant which initialized an automatic variable of
type struct cred.  This way the kmalloc/kfree pair would fall away.

access is actually used frequently.  For instance, ld.so uses it on
every startup as a quicker possibility to check for a file which
usually doesn't exist.  So, speeding up access has some small effect
on performance.  The resulting code might actually reduce the kernel
size a bit due to all the checks and calls which go away.
