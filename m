Return-Path: <linux-kernel-owner+w=401wt.eu-S1756067Ab0A1Bye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067Ab0A1Bye (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 20:54:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756053Ab0A1Byd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 20:54:33 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:44331 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755918Ab0A1Byc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 20:54:32 -0500
Date: Thu, 28 Jan 2010 01:54:30 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mimi Zohar <zohar@linux.vnet.ibm.com>, Eric Paris <eparis@redhat.com>
Subject: Re: linux-next: vfs tree build failure
Message-ID: <20100128015430.GN19799@ZenIV.linux.org.uk>
References: <20100128120000.cd804756.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100128120000.cd804756.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 28, 2010 at 12:00:00PM +1100, Stephen Rothwell wrote:
> Hi Al,
> 
> Today's linux-next build (powerpc ppc64_defconfig) failed like this:
> 
> fs/namei.c: In function 'do_filp_open':
> fs/namei.c:1740: error: too many arguments to function 'ima_file_check'
> fs/namei.c:1800: error: too many arguments to function 'ima_file_check'

Huh?  Oh...

ed include/linux/ima.h <<EOF
/static.*ima_file_check/s/)/, int mask&/
w
q
EOF

would fix it.
