Return-Path: <linux-kernel-owner+w=401wt.eu-S1756756AbXJIP5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756AbXJIP5o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 11:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754212AbXJIP5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 11:57:36 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:45940 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649AbXJIP5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 11:57:35 -0400
Date: Tue, 9 Oct 2007 08:56:36 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Rob Landley <rob@landley.net>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       rdunlap@xenotime.net
Subject: Re: [PATCH] Stop docproc segfaulting when SRCTREE isn't set.
Message-Id: <20071009085636.3e19a55a.randy.dunlap@oracle.com>
In-Reply-To: <200710090125.19089.rob@landley.net>
References: <200710090125.19089.rob@landley.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Oct 2007 01:25:18 -0500 Rob Landley wrote:

> From: Rob Landley <rob@landley.net>
> 
> Prevent docproc from segfaulting when SRCTREE isn't set.
> 
> Signed-off-by: Rob Landley <rob@landley.net>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

but needs 2 coding style fixes... see near end, below.

> ---
> 
>  scripts/basic/docproc.c |   10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff -r a26a53ed1101 scripts/basic/docproc.c
> --- a/scripts/basic/docproc.c	Sun Oct 07 16:42:22 2007 -0700
> +++ b/scripts/basic/docproc.c	Tue Oct 09 01:08:54 2007 -0500
> @@ -64,12 +64,15 @@ FILELINE * entity_system;
>  #define FUNCTION      "-function"
>  #define NOFUNCTION    "-nofunction"
>  
> +char *srctree;
> +
>  void usage (void)
>  {
>  	fprintf(stderr, "Usage: docproc {doc|depend} file\n");
>  	fprintf(stderr, "Input is read from file.tmpl. Output is sent to stdout\n");
>  	fprintf(stderr, "doc: frontend when generating kernel documentation\n");
>  	fprintf(stderr, "depend: generate list of files referenced within file\n");
> +	fprintf(stderr, "Environment variable SRCTREE: absolute path to kernel source tree.\n");
>  }
>  
>  /*
> @@ -88,7 +91,7 @@ void exec_kernel_doc(char **svec)
>  			exit(1);
>  		case  0:
>  			memset(real_filename, 0, sizeof(real_filename));
> -			strncat(real_filename, getenv("SRCTREE"), PATH_MAX);
> +			strncat(real_filename, srctree, PATH_MAX);
>  			strncat(real_filename, KERNELDOCPATH KERNELDOC,
>  					PATH_MAX - strlen(real_filename));
>  			execvp(real_filename, svec);
> @@ -168,7 +171,7 @@ void find_export_symbols(char * filename
>  	if (filename_exist(filename) == NULL) {
>  		char real_filename[PATH_MAX + 1];
>  		memset(real_filename, 0, sizeof(real_filename));
> -		strncat(real_filename, getenv("SRCTREE"), PATH_MAX);
> +		strncat(real_filename, srctree, PATH_MAX);
>  		strncat(real_filename, filename,
>  				PATH_MAX - strlen(real_filename));
>  		sym = add_new_file(filename);
> @@ -335,6 +338,9 @@ int main(int argc, char *argv[])
>  int main(int argc, char *argv[])
>  {
>  	FILE * infile;
> +
> +	srctree = getenv("SRCTREE");
> +	if (!srctree) srctree = getcwd(NULL,0);

	if (!srctree)
		srctree = getcwd(NULL, 0);

>  	if (argc != 3) {
>  		usage();
>  		exit(1);
> 
> -- 


---
~Randy
