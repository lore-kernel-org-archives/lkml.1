Return-Path: <linux-kernel-owner+w=401wt.eu-S1759202AbXIJSyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759202AbXIJSyR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 14:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752919AbXIJSyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 14:54:06 -0400
Received: from mail.fieldses.org ([66.93.2.214]:33913 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451AbXIJSyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 14:54:05 -0400
Date: Mon, 10 Sep 2007 14:54:00 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dcache: trivial comment fix
Message-ID: <20070910185400.GG2947@fieldses.org>
References: <20070910184632.GF2947@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070910184632.GF2947@fieldses.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2007 at 02:46:32PM -0400, J. Bruce Fields wrote:
>   * This forceful removal will result in ugly /proc output if
>   * somebody holds a file open that got deleted due to a rename.
>   * We could be nicer about the deleted file, and let it show
> - * up under the name it got deleted rather than the name that
> - * deleted it.
> + * up under the name it had before it was deleted rather than
> + * under the original name of the file that was moved on top of it.

By the way, on further examination of the code it doesn't actually do
what's described in the case where the target name is large and the
moved-from name is small.  Instead, it reports random garbage (usually
part of a name left over from some other dentry?) as far as I can tell:

from switch_names():


	if (dname_external(target)) {
                if (dname_external(dentry)) {
			...
                } else {
                        /*
                         * dentry:internal, target:external.  Steal target's
                         * storage and make target internal.
                         */
                        dentry->d_name.name = target->d_name.name;
                        target->d_name.name = target->d_iname;

... but target->d_iname could have anything in it, right?

--b.
