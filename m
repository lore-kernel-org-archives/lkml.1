Return-Path: <linux-kernel-owner+w=401wt.eu-S1753131AbZFFSKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbZFFSKj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 14:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751052AbZFFSKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 14:10:31 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:62674 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbZFFSKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 14:10:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QVxbHQMoa5wM53z/LEN3RKMfVc7La5hPAfTNGua2t0G39ez5FFnXA8zDevydcnWXUa
         gkqE8drgaW8ZonLG7R0WQwVsgYPf/6TajsVHP+r0/4KvcE9FCzYO4Zn3KCfWiCb52T2g
         CGVVo2ftvOdkMz/VTKIZ8fCbeeiPnoowGH80k=
Date: Sat, 6 Jun 2009 20:10:27 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter tools: Add 'perf
	annotate' feature
Message-ID: <20090606181023.GD6008@nowhere>
References: <tip-0b73da3f40128eab6ca2a07508f424029a1edaeb@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-0b73da3f40128eab6ca2a07508f424029a1edaeb@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 06, 2009 at 06:03:55PM +0000, tip-bot for Ingo Molnar wrote:
> Commit-ID:  0b73da3f40128eab6ca2a07508f424029a1edaeb
> Gitweb:     http://git.kernel.org/tip/0b73da3f40128eab6ca2a07508f424029a1edaeb
> Author:     Ingo Molnar <mingo@elte.hu>
> AuthorDate: Sat, 6 Jun 2009 15:48:52 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Sat, 6 Jun 2009 18:58:31 +0200
> 
> perf_counter tools: Add 'perf annotate' feature
> 
> Add new perf sub-command to display annotated source code:
> 
>  $ perf annotate decode_tree_entry
> 
> ------------------------------------------------
>  Percent |	Source code & Disassembly of /home/mingo/git/git
> ------------------------------------------------
>          :
>          :	/home/mingo/git/git:     file format elf64-x86-64
>          :
>          :
>          :	Disassembly of section .text:
>          :
>          :	00000000004a0da0 <decode_tree_entry>:
>          :		*modep = mode;
>          :		return str;
>          :	}
>          :
>          :	static void decode_tree_entry(struct tree_desc *desc, const char *buf, unsigned long size)
>          :	{
>     3.82 :	  4a0da0:	41 54                	push   %r12
>          :		const char *path;
>          :		unsigned int mode, len;
>          :
>          :		if (size < 24 || buf[size - 21])
>     0.17 :	  4a0da2:	48 83 fa 17          	cmp    $0x17,%rdx
>          :		*modep = mode;
>          :		return str;
>          :	}
>          :
>          :	static void decode_tree_entry(struct tree_desc *desc, const char *buf, unsigned long size)
>          :	{
>     0.00 :	  4a0da6:	49 89 fc             	mov    %rdi,%r12
>     0.00 :	  4a0da9:	55                   	push   %rbp
>     3.37 :	  4a0daa:	53                   	push   %rbx
>          :		const char *path;
>          :		unsigned int mode, len;
>          :
>          :		if (size < 24 || buf[size - 21])
>     0.08 :	  4a0dab:	76 73                	jbe    4a0e20 <decode_tree_entry+0x80>
>     0.00 :	  4a0dad:	80 7c 16 eb 00       	cmpb   $0x0,-0x15(%rsi,%rdx,1)
>     3.48 :	  4a0db2:	75 6c                	jne    4a0e20 <decode_tree_entry+0x80>
>          :	static const char *get_mode(const char *str, unsigned int *modep)
>          :	{
>          :		unsigned char c;
>          :		unsigned int mode = 0;
>          :
>          :		if (*str == ' ')
>     1.94 :	  4a0db4:	0f b6 06             	movzbl (%rsi),%eax
>     0.39 :	  4a0db7:	3c 20                	cmp    $0x20,%al
>     0.00 :	  4a0db9:	74 65                	je     4a0e20 <decode_tree_entry+0x80>
>          :			return NULL;
>          :
>          :		while ((c = *str++) != ' ') {
>     0.06 :	  4a0dbb:	89 c2                	mov    %eax,%edx
>          :			if (c < '0' || c > '7')
>     1.99 :	  4a0dbd:	31 ed                	xor    %ebp,%ebp
>          :		unsigned int mode = 0;
>          :
>          :		if (*str == ' ')
>          :			return NULL;
>          :
>          :		while ((c = *str++) != ' ') {
>     1.74 :	  4a0dbf:	48 8d 5e 01          	lea    0x1(%rsi),%rbx
>          :			if (c < '0' || c > '7')
>     0.00 :	  4a0dc3:	8d 42 d0             	lea    -0x30(%rdx),%eax
>     0.17 :	  4a0dc6:	3c 07                	cmp    $0x7,%al
>     0.00 :	  4a0dc8:	76 0d                	jbe    4a0dd7 <decode_tree_entry+0x37>
>     0.00 :	  4a0dca:	eb 54                	jmp    4a0e20 <decode_tree_entry+0x80>
>     0.00 :	  4a0dcc:	0f 1f 40 00          	nopl   0x0(%rax)
>    16.57 :	  4a0dd0:	8d 42 d0             	lea    -0x30(%rdx),%eax
>     0.14 :	  4a0dd3:	3c 07                	cmp    $0x7,%al
>     0.00 :	  4a0dd5:	77 49                	ja     4a0e20 <decode_tree_entry+0x80>
>          :				return NULL;
>          :			mode = (mode << 3) + (c - '0');
>     3.12 :	  4a0dd7:	0f b6 c2             	movzbl %dl,%eax
>          :		unsigned int mode = 0;
>          :
>          :		if (*str == ' ')
>          :			return NULL;
>          :
>          :		while ((c = *str++) != ' ') {
>     0.00 :	  4a0dda:	0f b6 13             	movzbl (%rbx),%edx
>    16.74 :	  4a0ddd:	48 83 c3 01          	add    $0x1,%rbx
>          :			if (c < '0' || c > '7')
>          :				return NULL;
>          :			mode = (mode << 3) + (c - '0');
> 
> The first column is the percentage of samples that arrived on that
> particular line - relative to the total cost of the function.




Wow!! Very impressive tool!!

Frederic.



> 
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> LKML-Reference: <new-submission>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> ---
>  .../perf_counter/Documentation/perf-annotate.txt   |    9 +-
>  Documentation/perf_counter/builtin-annotate.c      |  304 ++++++++++++--------
>  Documentation/perf_counter/util/symbol.c           |   50 +++-
>  Documentation/perf_counter/util/symbol.h           |    5 +
>  4 files changed, 229 insertions(+), 139 deletions(-)
> 
> diff --git a/Documentation/perf_counter/Documentation/perf-annotate.txt b/Documentation/perf_counter/Documentation/perf-annotate.txt
> index a9d6d5e..c9dcade 100644
> --- a/Documentation/perf_counter/Documentation/perf-annotate.txt
> +++ b/Documentation/perf_counter/Documentation/perf-annotate.txt
> @@ -3,7 +3,7 @@ perf-annotate(1)
>  
>  NAME
>  ----
> -perf-annotate - Read perf.data (created by perf record) and annotate functions
> +perf-annotate - Read perf.data (created by perf record) and display annotated code
>  
>  SYNOPSIS
>  --------
> @@ -12,8 +12,11 @@ SYNOPSIS
>  
>  DESCRIPTION
>  -----------
> -This command displays the performance counter profile information recorded
> -via perf record.
> +This command reads the input file and displays an annotated version of the
> +code. If the object file has debug symbols then the source code will be
> +displayed alongside assembly code.
> +
> +If there is no debug info in the object, then annotated assembly is displayed.
>  
>  OPTIONS
>  -------
> diff --git a/Documentation/perf_counter/builtin-annotate.c b/Documentation/perf_counter/builtin-annotate.c
> index d656484..116a397 100644
> --- a/Documentation/perf_counter/builtin-annotate.c
> +++ b/Documentation/perf_counter/builtin-annotate.c
> @@ -28,7 +28,7 @@
>  static char		const *input_name = "perf.data";
>  static char		*vmlinux = NULL;
>  
> -static char		default_sort_order[] = "comm,dso";
> +static char		default_sort_order[] = "comm,symbol";
>  static char		*sort_order = default_sort_order;
>  
>  static int		input;
> @@ -38,7 +38,6 @@ static int		dump_trace = 0;
>  #define dprintf(x...)	do { if (dump_trace) printf(x); } while (0)
>  
>  static int		verbose;
> -static int		full_paths;
>  
>  static unsigned long	page_size;
>  static unsigned long	mmap_window = 32;
> @@ -89,6 +88,7 @@ static LIST_HEAD(dsos);
>  static struct dso *kernel_dso;
>  static struct dso *vdso;
>  
> +
>  static void dsos__add(struct dso *dso)
>  {
>  	list_add_tail(&dso->node, &dsos);
> @@ -176,20 +176,6 @@ static int load_kernel(void)
>  	return err;
>  }
>  
> -static char __cwd[PATH_MAX];
> -static char *cwd = __cwd;
> -static int cwdlen;
> -
> -static int strcommon(const char *pathname)
> -{
> -	int n = 0;
> -
> -	while (pathname[n] == cwd[n] && n < cwdlen)
> -		++n;
> -
> -	return n;
> -}
> -
>  struct map {
>  	struct list_head node;
>  	uint64_t	 start;
> @@ -215,17 +201,6 @@ static struct map *map__new(struct mmap_event *event)
>  
>  	if (self != NULL) {
>  		const char *filename = event->filename;
> -		char newfilename[PATH_MAX];
> -
> -		if (cwd) {
> -			int n = strcommon(filename);
> -
> -			if (n == cwdlen) {
> -				snprintf(newfilename, sizeof(newfilename),
> -					 ".%s", filename + n);
> -				filename = newfilename;
> -			}
> -		}
>  
>  		self->start = event->start;
>  		self->end   = event->start + event->len;
> @@ -669,44 +644,36 @@ hist_entry__collapse(struct hist_entry *left, struct hist_entry *right)
>  	return cmp;
>  }
>  
> -static size_t
> -hist_entry__fprintf(FILE *fp, struct hist_entry *self, uint64_t total_samples)
> +/*
> + * collect histogram counts
> + */
> +static void hist_hit(struct hist_entry *he, uint64_t ip)
>  {
> -	struct sort_entry *se;
> -	size_t ret;
> +	unsigned int sym_size, offset;
> +	struct symbol *sym = he->sym;
>  
> -	if (total_samples) {
> -		double percent = self->count * 100.0 / total_samples;
> -		char *color = PERF_COLOR_NORMAL;
> +	he->count++;
>  
> -		/*
> -		 * We color high-overhead entries in red, low-overhead
> -		 * entries in green - and keep the middle ground normal:
> -		 */
> -		if (percent >= 5.0)
> -			color = PERF_COLOR_RED;
> -		if (percent < 0.5)
> -			color = PERF_COLOR_GREEN;
> +	if (!sym || !sym->hist)
> +		return;
>  
> -		ret = color_fprintf(fp, color, "   %6.2f%%",
> -				(self->count * 100.0) / total_samples);
> -	} else
> -		ret = fprintf(fp, "%12d ", self->count);
> +	sym_size = sym->end - sym->start;
> +	offset = ip - sym->start;
>  
> -	list_for_each_entry(se, &hist_entry__sort_list, list) {
> -		fprintf(fp, "  ");
> -		ret += se->print(fp, self);
> -	}
> +	if (offset >= sym_size)
> +		return;
>  
> -	ret += fprintf(fp, "\n");
> +	sym->hist_sum++;
> +	sym->hist[offset]++;
>  
> -	return ret;
> +	if (verbose >= 3)
> +		printf("%p %s: count++ [ip: %p, %08Lx] => %Ld\n",
> +			(void *)he->sym->start,
> +			he->sym->name,
> +			(void *)ip, ip - he->sym->start,
> +			sym->hist[offset]);
>  }
>  
> -/*
> - * collect histogram counts
> - */
> -
>  static int
>  hist_entry__add(struct thread *thread, struct map *map, struct dso *dso,
>  		struct symbol *sym, uint64_t ip, char level)
> @@ -732,7 +699,8 @@ hist_entry__add(struct thread *thread, struct map *map, struct dso *dso,
>  		cmp = hist_entry__cmp(&entry, he);
>  
>  		if (!cmp) {
> -			he->count++;
> +			hist_hit(he, ip);
> +
>  			return 0;
>  		}
>  
> @@ -856,50 +824,6 @@ static void output__resort(void)
>  	}
>  }
>  
> -static size_t output__fprintf(FILE *fp, uint64_t total_samples)
> -{
> -	struct hist_entry *pos;
> -	struct sort_entry *se;
> -	struct rb_node *nd;
> -	size_t ret = 0;
> -
> -	fprintf(fp, "\n");
> -	fprintf(fp, "#\n");
> -	fprintf(fp, "# (%Ld samples)\n", (__u64)total_samples);
> -	fprintf(fp, "#\n");
> -
> -	fprintf(fp, "# Overhead");
> -	list_for_each_entry(se, &hist_entry__sort_list, list)
> -		fprintf(fp, "  %s", se->header);
> -	fprintf(fp, "\n");
> -
> -	fprintf(fp, "# ........");
> -	list_for_each_entry(se, &hist_entry__sort_list, list) {
> -		int i;
> -
> -		fprintf(fp, "  ");
> -		for (i = 0; i < strlen(se->header); i++)
> -			fprintf(fp, ".");
> -	}
> -	fprintf(fp, "\n");
> -
> -	fprintf(fp, "#\n");
> -
> -	for (nd = rb_first(&output_hists); nd; nd = rb_next(nd)) {
> -		pos = rb_entry(nd, struct hist_entry, rb_node);
> -		ret += hist_entry__fprintf(fp, pos, total_samples);
> -	}
> -
> -	if (!strcmp(sort_order, default_sort_order)) {
> -		fprintf(fp, "#\n");
> -		fprintf(fp, "# (For more details, try: perf annotate --sort comm,dso,symbol)\n");
> -		fprintf(fp, "#\n");
> -	}
> -	fprintf(fp, "\n");
> -
> -	return ret;
> -}
> -
>  static void register_idle_thread(void)
>  {
>  	struct thread *thread = threads__findnew(0);
> @@ -1106,6 +1030,149 @@ process_event(event_t *event, unsigned long offset, unsigned long head)
>  	return 0;
>  }
>  
> +static int
> +parse_line(FILE *file, struct symbol *sym, uint64_t start, uint64_t len)
> +{
> +	char *line = NULL, *tmp, *tmp2;
> +	unsigned int offset;
> +	size_t line_len;
> +	__u64 line_ip;
> +	int ret;
> +	char *c;
> +
> +	if (getline(&line, &line_len, file) < 0)
> +		return -1;
> +	if (!line)
> +		return -1;
> +
> +	c = strchr(line, '\n');
> +	if (c)
> +		*c = 0;
> +
> +	line_ip = -1;
> +	offset = 0;
> +	ret = -2;
> +
> +	/*
> +	 * Strip leading spaces:
> +	 */
> +	tmp = line;
> +	while (*tmp) {
> +		if (*tmp != ' ')
> +			break;
> +		tmp++;
> +	}
> +
> +	if (*tmp) {
> +		/*
> +		 * Parse hexa addresses followed by ':'
> +		 */
> +		line_ip = strtoull(tmp, &tmp2, 16);
> +		if (*tmp2 != ':')
> +			line_ip = -1;
> +	}
> +
> +	if (line_ip != -1) {
> +		unsigned int hits = 0;
> +		double percent = 0.0;
> +		char *color = PERF_COLOR_NORMAL;
> +
> +		offset = line_ip - start;
> +		if (offset < len)
> +			hits = sym->hist[offset];
> +
> +		if (sym->hist_sum)
> +			percent = 100.0 * hits / sym->hist_sum;
> +
> +		/*
> +		 * We color high-overhead entries in red, low-overhead
> +		 * entries in green - and keep the middle ground normal:
> +		 */
> +		if (percent >= 5.0)
> +			color = PERF_COLOR_RED;
> +		else {
> +			if (percent > 0.5)
> +				color = PERF_COLOR_GREEN;
> +		}
> +
> +		color_fprintf(stdout, color, " %7.2f", percent);
> +		printf(" :	");
> +		color_fprintf(stdout, PERF_COLOR_BLUE, "%s\n", line);
> +	} else {
> +		if (!*line)
> +			printf("         :\n");
> +		else
> +			printf("         :	%s\n", line);
> +	}
> +
> +	return 0;
> +}
> +
> +static void annotate_sym(struct dso *dso, struct symbol *sym)
> +{
> +	char *filename = dso->name;
> +	uint64_t start, end, len;
> +	char command[PATH_MAX*2];
> +	FILE *file;
> +
> +	if (!filename)
> +		return;
> +	if (dso == kernel_dso)
> +		filename = vmlinux;
> +
> +	printf("\n------------------------------------------------\n");
> +	printf(" Percent |	Source code & Disassembly of %s\n", filename);
> +	printf("------------------------------------------------\n");
> +
> +	if (verbose >= 2)
> +		printf("annotating [%p] %30s : [%p] %30s\n", dso, dso->name, sym, sym->name);
> +
> +	start = sym->obj_start;
> +	if (!start)
> +		start = sym->start;
> +
> +	end = start + sym->end - sym->start + 1;
> +	len = sym->end - sym->start;
> +
> +	sprintf(command, "objdump --start-address=0x%016Lx --stop-address=0x%016Lx -dS %s", (__u64)start, (__u64)end, filename);
> +
> +	if (verbose >= 3)
> +		printf("doing: %s\n", command);
> +
> +	file = popen(command, "r");
> +	if (!file)
> +		return;
> +
> +	while (!feof(file)) {
> +		if (parse_line(file, sym, start, len) < 0)
> +			break;
> +	}
> +
> +	pclose(file);
> +}
> +
> +static void find_annotations(void)
> +{
> +	struct rb_node *nd;
> +	struct dso *dso;
> +	int count = 0;
> +
> +	list_for_each_entry(dso, &dsos, node) {
> +
> +		for (nd = rb_first(&dso->syms); nd; nd = rb_next(nd)) {
> +			struct symbol *sym = rb_entry(nd, struct symbol, rb_node);
> +
> +			if (sym->hist) {
> +				annotate_sym(dso, sym);
> +				count++;
> +			}
> +		}
> +	}
> +
> +	if (!count)
> +		printf(" Error: symbol '%s' not present amongst the samples.\n", sym_hist_filter);
> +}
> +
>  static int __cmd_annotate(void)
>  {
>  	int ret, rc = EXIT_FAILURE;
> @@ -1140,16 +1207,6 @@ static int __cmd_annotate(void)
>  		return EXIT_FAILURE;
>  	}
>  
> -	if (!full_paths) {
> -		if (getcwd(__cwd, sizeof(__cwd)) == NULL) {
> -			perror("failed to get the current directory");
> -			return EXIT_FAILURE;
> -		}
> -		cwdlen = strlen(cwd);
> -	} else {
> -		cwd = NULL;
> -		cwdlen = 0;
> -	}
>  remap:
>  	buf = (char *)mmap(NULL, page_size * mmap_window, PROT_READ,
>  			   MAP_SHARED, input, offset);
> @@ -1229,7 +1286,8 @@ more:
>  
>  	collapse__resort();
>  	output__resort();
> -	output__fprintf(stdout, total);
> +
> +	find_annotations();
>  
>  	return rc;
>  }
> @@ -1242,15 +1300,13 @@ static const char * const annotate_usage[] = {
>  static const struct option options[] = {
>  	OPT_STRING('i', "input", &input_name, "file",
>  		    "input file name"),
> +	OPT_STRING('s', "symbol", &sym_hist_filter, "file",
> +		    "symbol to annotate"),
>  	OPT_BOOLEAN('v', "verbose", &verbose,
>  		    "be more verbose (show symbol address, etc)"),
>  	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
>  		    "dump raw trace in ASCII"),
>  	OPT_STRING('k', "vmlinux", &vmlinux, "file", "vmlinux pathname"),
> -	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
> -		   "sort by key(s): pid, comm, dso, symbol. Default: pid,symbol"),
> -	OPT_BOOLEAN('P', "full-paths", &full_paths,
> -		    "Don't shorten the pathnames taking into account the cwd"),
>  	OPT_END()
>  };
>  
> @@ -1279,10 +1335,18 @@ int cmd_annotate(int argc, const char **argv, const char *prefix)
>  
>  	setup_sorting();
>  
> -	/*
> -	 * Any (unrecognized) arguments left?
> -	 */
> -	if (argc)
> +	if (argc) {
> +		/*
> +		 * Special case: if there's an argument left then assume tha
> +		 * it's a symbol filter:
> +		 */
> +		if (argc > 1)
> +			usage_with_options(annotate_usage, options);
> +
> +		sym_hist_filter = argv[0];
> +	}
> +
> +	if (!sym_hist_filter)
>  		usage_with_options(annotate_usage, options);
>  
>  	setup_pager();
> diff --git a/Documentation/perf_counter/util/symbol.c b/Documentation/perf_counter/util/symbol.c
> index a06bbfb..23f4f7b 100644
> --- a/Documentation/perf_counter/util/symbol.c
> +++ b/Documentation/perf_counter/util/symbol.c
> @@ -7,21 +7,36 @@
>  #include <gelf.h>
>  #include <elf.h>
>  
> +const char *sym_hist_filter;
> +
>  static struct symbol *symbol__new(uint64_t start, uint64_t len,
> -				  const char *name, unsigned int priv_size)
> +				  const char *name, unsigned int priv_size,
> +				  uint64_t obj_start, int verbose)
>  {
>  	size_t namelen = strlen(name) + 1;
> -	struct symbol *self = malloc(priv_size + sizeof(*self) + namelen);
> +	struct symbol *self = calloc(1, priv_size + sizeof(*self) + namelen);
>  
> -	if (self != NULL) {
> -		if (priv_size) {
> -			memset(self, 0, priv_size);
> -			self = ((void *)self) + priv_size;
> -		}
> -		self->start = start;
> -		self->end   = start + len - 1;
> -		memcpy(self->name, name, namelen);
> +	if (!self)
> +		return NULL;
> +
> +	if (verbose >= 2)
> +		printf("new symbol: %016Lx [%08lx]: %s, hist: %p, obj_start: %p\n",
> +			(__u64)start, len, name, self->hist, (void *)obj_start);
> +
> +	self->obj_start= obj_start;
> +	self->hist = NULL;
> +	self->hist_sum = 0;
> +
> +	if (sym_hist_filter && !strcmp(name, sym_hist_filter))
> +		self->hist = calloc(sizeof(__u64), len);
> +
> +	if (priv_size) {
> +		memset(self, 0, priv_size);
> +		self = ((void *)self) + priv_size;
>  	}
> +	self->start = start;
> +	self->end   = start + len - 1;
> +	memcpy(self->name, name, namelen);
>  
>  	return self;
>  }
> @@ -166,7 +181,7 @@ static int dso__load_kallsyms(struct dso *self, symbol_filter_t filter, int verb
>  		 * Well fix up the end later, when we have all sorted.
>  		 */
>  		sym = symbol__new(start, 0xdead, line + len + 2,
> -				  self->sym_priv_size);
> +				  self->sym_priv_size, 0, verbose);
>  
>  		if (sym == NULL)
>  			goto out_delete_line;
> @@ -272,7 +287,7 @@ static Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
>  static int dso__synthesize_plt_symbols(struct  dso *self, Elf *elf,
>  				       GElf_Ehdr *ehdr, Elf_Scn *scn_dynsym,
>  				       GElf_Shdr *shdr_dynsym,
> -				       size_t dynsym_idx)
> +				       size_t dynsym_idx, int verbose)
>  {
>  	uint32_t nr_rel_entries, idx;
>  	GElf_Sym sym;
> @@ -335,7 +350,7 @@ static int dso__synthesize_plt_symbols(struct  dso *self, Elf *elf,
>  				 "%s@plt", elf_sym__name(&sym, symstrs));
>  
>  			f = symbol__new(plt_offset, shdr_plt.sh_entsize,
> -					sympltname, self->sym_priv_size);
> +					sympltname, self->sym_priv_size, 0, verbose);
>  			if (!f)
>  				return -1;
>  
> @@ -353,7 +368,7 @@ static int dso__synthesize_plt_symbols(struct  dso *self, Elf *elf,
>  				 "%s@plt", elf_sym__name(&sym, symstrs));
>  
>  			f = symbol__new(plt_offset, shdr_plt.sh_entsize,
> -					sympltname, self->sym_priv_size);
> +					sympltname, self->sym_priv_size, 0, verbose);
>  			if (!f)
>  				return -1;
>  
> @@ -410,7 +425,7 @@ static int dso__load_sym(struct dso *self, int fd, const char *name,
>  	if (sec_dynsym != NULL) {
>  		nr = dso__synthesize_plt_symbols(self, elf, &ehdr,
>  						 sec_dynsym, &shdr,
> -						 dynsym_idx);
> +						 dynsym_idx, verbose);
>  		if (nr < 0)
>  			goto out_elf_end;
>  	}
> @@ -444,6 +459,7 @@ static int dso__load_sym(struct dso *self, int fd, const char *name,
>  
>  	elf_symtab__for_each_symbol(syms, nr_syms, index, sym) {
>  		struct symbol *f;
> +		uint64_t obj_start;
>  
>  		if (!elf_sym__is_function(&sym))
>  			continue;
> @@ -453,11 +469,13 @@ static int dso__load_sym(struct dso *self, int fd, const char *name,
>  			goto out_elf_end;
>  
>  		gelf_getshdr(sec, &shdr);
> +		obj_start = sym.st_value;
> +
>  		sym.st_value -= shdr.sh_addr - shdr.sh_offset;
>  
>  		f = symbol__new(sym.st_value, sym.st_size,
>  				elf_sym__name(&sym, symstrs),
> -				self->sym_priv_size);
> +				self->sym_priv_size, obj_start, verbose);
>  		if (!f)
>  			goto out_elf_end;
>  
> diff --git a/Documentation/perf_counter/util/symbol.h b/Documentation/perf_counter/util/symbol.h
> index e23cc31..4839d68 100644
> --- a/Documentation/perf_counter/util/symbol.h
> +++ b/Documentation/perf_counter/util/symbol.h
> @@ -9,6 +9,9 @@ struct symbol {
>  	struct rb_node	rb_node;
>  	__u64		start;
>  	__u64		end;
> +	__u64		obj_start;
> +	__u64		hist_sum;
> +	__u64		*hist;
>  	char		name[0];
>  };
>  
> @@ -20,6 +23,8 @@ struct dso {
>  	char		 name[0];
>  };
>  
> +const char *sym_hist_filter;
> +
>  typedef int (*symbol_filter_t)(struct dso *self, struct symbol *sym);
>  
>  struct dso *dso__new(const char *name, unsigned int sym_priv_size);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-tip-commits" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

