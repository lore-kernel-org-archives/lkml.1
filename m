Return-Path: <linux-kernel-owner+w=401wt.eu-S1761451AbYA3KYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761451AbYA3KYz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 05:24:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755403AbYA3KYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 05:24:44 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:42670 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759272AbYA3KYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 05:24:43 -0500
Date: Wed, 30 Jan 2008 11:24:42 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Bryan Wu <bryan.wu@analog.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] [Scripts] add svn revision information to setlocalversion
Message-ID: <20080130102442.GB20846@uranus.ravnborg.org>
References: <1201688125-1387-1-git-send-email-bryan.wu@analog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201688125-1387-1-git-send-email-bryan.wu@analog.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2008 at 06:15:25PM +0800, Bryan Wu wrote:
> Signed-off-by: Bryan Wu <bryan.wu@analog.com>
> ---
>  scripts/setlocalversion |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/scripts/setlocalversion b/scripts/setlocalversion
> index 52f032e..2d6645c 100644
> --- a/scripts/setlocalversion
> +++ b/scripts/setlocalversion
> @@ -25,6 +25,10 @@ if head=`git rev-parse --verify HEAD 2>/dev/null`; then
>  	# All done with git
>  	exit
>  fi
> +# Check for svn and a svn repo.
> +if rev=`svn info 2>/dev/null | grep '^Revision' | awk '{print $NF}'` ; then
> +        printf -- '-svn%s' $rev
> +fi
>  
>  # Check for mercurial and a mercurial repo.
>  if hgid=`hg id 2>/dev/null`; then

Hi Bryna.

Can I ask you to change the shell script to use
a chained if so if we find git we do not try mercurial nor svn.

I should have done so initially when adding the patch with mercurial
support but it slipped my mind.

	Sam
