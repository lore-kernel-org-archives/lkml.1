Return-Path: <linux-kernel-owner+w=401wt.eu-S1756814AbYJHXM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814AbYJHXM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 19:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754466AbYJHXMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 19:12:18 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:31495 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754799AbYJHXMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 19:12:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=IfD2loyxikgvoLgEP13pV4Fsc5AV/AuD+YwaZGSRfJrTp0Q3eWn4CM2QQDfG7bjyRn
         8yootCV6aw3fMGJHKP1LYrCF4V2+tmAOuRzHEgdtpu7TQpH7SIe7wQA/3+ZOy2HFTBnl
         LydtTKX/a8OjH9vgw1v8PfvRLz3XJTxuU8Y4g=
Message-ID: <a4e6962a0810081612i7f30ec16gf727da56816530ab@mail.gmail.com>
Date: Wed, 8 Oct 2008 18:12:17 -0500
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: "Latchesar Ionkov" <lucho@ionkov.net>
Subject: Re: [V9fs-developer] [PATCH 04/10] 9p: move dirread to fs layer
Cc: linux-kernel@vger.kernel.org, v9fs-developer@lists.sourceforge.net
In-Reply-To: <f158dc670810081510t3b5be588v8298aa20a26039c5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1223500147-19654-5-git-send-email-ericvh@gmail.com>
	 <f158dc670810081510t3b5be588v8298aa20a26039c5@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 8, 2008 at 5:10 PM, Latchesar Ionkov <lucho@ionkov.net> wrote:
> The idea of the client implementation is to be able to use it not only
> from the vfs layer, but also without it. For example, creating a
> device that connect to a remote 9P file server.
>

That does make sense in principal -- although I'm not sure filldir
structures are the easiest things to work with either.   The main idea
was to restrict the client.c code to wire operations, primarily
torwards the idea of treating the "client" as a proxy server once the
in-kernel-server code goes in (hopefully in 2.6.29).
Of course the other factor is that this patch-set is gearing up
towards an alternate extended-POSIX-support approach (what I've been
referring to as .L) -- that extension will include a wire operation
which more closely matches linux's concept of dirread (just grab the
files, not the associated stat) -- but whether or not that is useful
will largely depend on what sort of remote server you are accessing.

The Plan 9 dirread is one of those special cases where even though its
not a wire operation, it needs some intimate understanding of the
underlying protocol (at least  how stats get marshalled) -- in some
ways if it were a client operation, it might make more sense to pass
it an array of p9_stat structs to populate with the results.

Do you have some code which used the old client interface I could look
at or were you just thinking towards the future?

         -eric
