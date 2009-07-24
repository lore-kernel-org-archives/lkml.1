Return-Path: <linux-kernel-owner+w=401wt.eu-S1753619AbZGXRu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619AbZGXRu2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 13:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbZGXRu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 13:50:27 -0400
Received: from mail-px0-f184.google.com ([209.85.216.184]:58199 "EHLO
	mail-px0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529AbZGXRu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 13:50:26 -0400
Subject: [PATCH] kbuild: add static to prototypes
From: Trevor Keith <tsrk@tsrk.net>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, sam@ravnborg.org, linux-kbuild@vger.kernel.org
Content-Type: text/plain
Date: Fri, 24 Jul 2009 10:50:02 -0700
Message-Id: <1248457802.13544.6.camel@tsrk-ibm>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Warnings found via gcc -Wmissing-prototypes.

Signed-off-by: Trevor Keith <tsrk@tsrk.net>
---
 scripts/basic/docproc.c     |   34 +++++++++++++++++-----------------
 scripts/basic/fixdep.c      |   26 +++++++++++++-------------
 scripts/basic/hash.c        |    4 ++--
 scripts/kconfig/conf.c      |    2 +-
 scripts/kconfig/confdata.c  |    2 +-
 scripts/kconfig/expr.c      |    4 ++--
 scripts/kconfig/kxgettext.c |    4 ++--
 scripts/kconfig/menu.c      |    4 ++--
 scripts/kconfig/symbol.c    |    6 +++---
 9 files changed, 43 insertions(+), 43 deletions(-)

diff --git a/scripts/basic/docproc.c b/scripts/basic/docproc.c
index 99ca7a6..79ab973 100644
--- a/scripts/basic/docproc.c
+++ b/scripts/basic/docproc.c
@@ -71,7 +71,7 @@ FILELINE * docsection;
 
 static char *srctree, *kernsrctree;
 
-void usage (void)
+static void usage (void)
 {
 	fprintf(stderr, "Usage: docproc {doc|depend} file\n");
 	fprintf(stderr, "Input is read from file.tmpl. Output is sent to stdout\n");
@@ -84,7 +84,7 @@ void usage (void)
 /*
  * Execute kernel-doc with parameters given in svec
  */
-void exec_kernel_doc(char **svec)
+static void exec_kernel_doc(char **svec)
 {
 	pid_t pid;
 	int ret;
@@ -129,7 +129,7 @@ struct symfile
 struct symfile symfilelist[MAXFILES];
 int symfilecnt = 0;
 
-void add_new_symbol(struct symfile *sym, char * symname)
+static void add_new_symbol(struct symfile *sym, char * symname)
 {
 	sym->symbollist =
           realloc(sym->symbollist, (sym->symbolcnt + 1) * sizeof(char *));
@@ -137,14 +137,14 @@ void add_new_symbol(struct symfile *sym, char * symname)
 }
 
 /* Add a filename to the list */
-struct symfile * add_new_file(char * filename)
+static struct symfile * add_new_file(char * filename)
 {
 	symfilelist[symfilecnt++].filename = strdup(filename);
 	return &symfilelist[symfilecnt - 1];
 }
 
 /* Check if file already are present in the list */
-struct symfile * filename_exist(char * filename)
+static struct symfile * filename_exist(char * filename)
 {
 	int i;
 	for (i=0; i < symfilecnt; i++)
@@ -157,20 +157,20 @@ struct symfile * filename_exist(char * filename)
  * List all files referenced within the template file.
  * Files are separated by tabs.
  */
-void adddep(char * file)		   { printf("\t%s", file); }
-void adddep2(char * file, char * line)     { line = line; adddep(file); }
-void noaction(char * line)		   { line = line; }
-void noaction2(char * file, char * line)   { file = file; line = line; }
+static void adddep(char * file)		   { printf("\t%s", file); }
+static void adddep2(char * file, char * line)     { line = line; adddep(file); }
+static void noaction(char * line)		   { line = line; }
+static void noaction2(char * file, char * line)   { file = file; line = line; }
 
 /* Echo the line without further action */
-void printline(char * line)               { printf("%s", line); }
+static void printline(char * line)               { printf("%s", line); }
 
 /*
  * Find all symbols in filename that are exported with EXPORT_SYMBOL &
  * EXPORT_SYMBOL_GPL (& EXPORT_SYMBOL_GPL_FUTURE implicitly).
  * All symbols located are stored in symfilelist.
  */
-void find_export_symbols(char * filename)
+static void find_export_symbols(char * filename)
 {
 	FILE * fp;
 	struct symfile *sym;
@@ -227,7 +227,7 @@ void find_export_symbols(char * filename)
  * intfunc uses -nofunction
  * extfunc uses -function
  */
-void docfunctions(char * filename, char * type)
+static void docfunctions(char * filename, char * type)
 {
 	int i,j;
 	int symcnt = 0;
@@ -258,15 +258,15 @@ void docfunctions(char * filename, char * type)
 	fflush(stdout);
 	free(vec);
 }
-void intfunc(char * filename) {	docfunctions(filename, NOFUNCTION); }
-void extfunc(char * filename) { docfunctions(filename, FUNCTION);   }
+static void intfunc(char * filename) {	docfunctions(filename, NOFUNCTION); }
+static void extfunc(char * filename) { docfunctions(filename, FUNCTION);   }
 
 /*
  * Document specific function(s) in a file.
  * Call kernel-doc with the following parameters:
  * kernel-doc -docbook -function function1 [-function function2]
  */
-void singfunc(char * filename, char * line)
+static void singfunc(char * filename, char * line)
 {
 	char *vec[200]; /* Enough for specific functions */
         int i, idx = 0;
@@ -297,7 +297,7 @@ void singfunc(char * filename, char * line)
  * Call kernel-doc with the following parameters:
  * kernel-doc -docbook -function "doc section" filename
  */
-void docsect(char *filename, char *line)
+static void docsect(char *filename, char *line)
 {
 	char *vec[6]; /* kerneldoc -docbook -function "section" file NULL */
 	char *s;
@@ -324,7 +324,7 @@ void docsect(char *filename, char *line)
  * 5) Lines containing !P
  * 6) Default lines - lines not matching the above
  */
-void parse_file(FILE *infile)
+static void parse_file(FILE *infile)
 {
 	char line[MAXLINESZ];
 	char * s;
diff --git a/scripts/basic/fixdep.c b/scripts/basic/fixdep.c
index 72c1520..d7c1b04 100644
--- a/scripts/basic/fixdep.c
+++ b/scripts/basic/fixdep.c
@@ -125,7 +125,7 @@ char *target;
 char *depfile;
 char *cmdline;
 
-void usage(void)
+static void usage(void)
 
 {
 	fprintf(stderr, "Usage: fixdep <depfile> <target> <cmdline>\n");
@@ -135,7 +135,7 @@ void usage(void)
 /*
  * Print out the commandline prefixed with cmd_<target filename> :=
  */
-void print_cmdline(void)
+static void print_cmdline(void)
 {
 	printf("cmd_%s := %s\n\n", target, cmdline);
 }
@@ -148,7 +148,7 @@ int    len_config  = 0;
  * Grow the configuration string to a desired length.
  * Usually the first growth is plenty.
  */
-void grow_config(int len)
+static void grow_config(int len)
 {
 	while (len_config + len > size_config) {
 		if (size_config == 0)
@@ -164,7 +164,7 @@ void grow_config(int len)
 /*
  * Lookup a value in the configuration string.
  */
-int is_defined_config(const char * name, int len)
+static int is_defined_config(const char * name, int len)
 {
 	const char * pconfig;
 	const char * plast = str_config + len_config - len;
@@ -180,7 +180,7 @@ int is_defined_config(const char * name, int len)
 /*
  * Add a new value to the configuration string.
  */
-void define_config(const char * name, int len)
+static void define_config(const char * name, int len)
 {
 	grow_config(len + 1);
 
@@ -192,7 +192,7 @@ void define_config(const char * name, int len)
 /*
  * Clear the set of configuration strings.
  */
-void clear_config(void)
+static void clear_config(void)
 {
 	len_config = 0;
 	define_config("", 0);
@@ -201,7 +201,7 @@ void clear_config(void)
 /*
  * Record the use of a CONFIG_* word.
  */
-void use_config(char *m, int slen)
+static void use_config(char *m, int slen)
 {
 	char s[PATH_MAX];
 	char *p;
@@ -222,7 +222,7 @@ void use_config(char *m, int slen)
 	printf("    $(wildcard include/config/%s.h) \\\n", s);
 }
 
-void parse_config_file(char *map, size_t len)
+static void parse_config_file(char *map, size_t len)
 {
 	int *end = (int *) (map + len);
 	/* start at +1, so that p can never be < map */
@@ -256,7 +256,7 @@ void parse_config_file(char *map, size_t len)
 }
 
 /* test is s ends in sub */
-int strrcmp(char *s, char *sub)
+static int strrcmp(char *s, char *sub)
 {
 	int slen = strlen(s);
 	int sublen = strlen(sub);
@@ -267,7 +267,7 @@ int strrcmp(char *s, char *sub)
 	return memcmp(s + slen - sublen, sub, sublen);
 }
 
-void do_config_file(char *filename)
+static void do_config_file(char *filename)
 {
 	struct stat st;
 	int fd;
@@ -298,7 +298,7 @@ void do_config_file(char *filename)
 	close(fd);
 }
 
-void parse_dep_file(void *map, size_t len)
+static void parse_dep_file(void *map, size_t len)
 {
 	char *m = map;
 	char *end = m + len;
@@ -338,7 +338,7 @@ void parse_dep_file(void *map, size_t len)
 	printf("$(deps_%s):\n", target);
 }
 
-void print_deps(void)
+static void print_deps(void)
 {
 	struct stat st;
 	int fd;
@@ -370,7 +370,7 @@ void print_deps(void)
 	close(fd);
 }
 
-void traps(void)
+static void traps(void)
 {
 	static char test[] __attribute__((aligned(sizeof(int)))) = "CONF";
 	int *p = (int *)test;
diff --git a/scripts/basic/hash.c b/scripts/basic/hash.c
index 3299ad7..2ef5d3f 100644
--- a/scripts/basic/hash.c
+++ b/scripts/basic/hash.c
@@ -21,7 +21,7 @@ static void usage(void)
  * http://www.cse.yorku.ca/~oz/hash.html
  */
 
-unsigned int djb2_hash(char *str)
+static unsigned int djb2_hash(char *str)
 {
 	unsigned long hash = 5381;
 	int c;
@@ -34,7 +34,7 @@ unsigned int djb2_hash(char *str)
 	return (unsigned int)(hash & ((1 << DYNAMIC_DEBUG_HASH_BITS) - 1));
 }
 
-unsigned int r5_hash(char *str)
+static unsigned int r5_hash(char *str)
 {
 	unsigned long hash = 0;
 	int c;
diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index 3baaaec..028d9e4 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -121,7 +121,7 @@ static int conf_askvalue(struct symbol *sym, const char *def)
 	return 1;
 }
 
-int conf_string(struct menu *menu)
+static int conf_string(struct menu *menu)
 {
 	struct symbol *sym = menu->sym;
 	const char *def;
diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index a04da34..b55e72f 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -560,7 +560,7 @@ int conf_write(const char *name)
 	return 0;
 }
 
-int conf_split_config(void)
+static int conf_split_config(void)
 {
 	const char *name;
 	char path[128];
diff --git a/scripts/kconfig/expr.c b/scripts/kconfig/expr.c
index 579ece4..b2fc607 100644
--- a/scripts/kconfig/expr.c
+++ b/scripts/kconfig/expr.c
@@ -348,7 +348,7 @@ struct expr *expr_trans_bool(struct expr *e)
 /*
  * e1 || e2 -> ?
  */
-struct expr *expr_join_or(struct expr *e1, struct expr *e2)
+static struct expr *expr_join_or(struct expr *e1, struct expr *e2)
 {
 	struct expr *tmp;
 	struct symbol *sym1, *sym2;
@@ -412,7 +412,7 @@ struct expr *expr_join_or(struct expr *e1, struct expr *e2)
 	return NULL;
 }
 
-struct expr *expr_join_and(struct expr *e1, struct expr *e2)
+static struct expr *expr_join_and(struct expr *e1, struct expr *e2)
 {
 	struct expr *tmp;
 	struct symbol *sym1, *sym2;
diff --git a/scripts/kconfig/kxgettext.c b/scripts/kconfig/kxgettext.c
index 8d9ce22..dcc3fcc 100644
--- a/scripts/kconfig/kxgettext.c
+++ b/scripts/kconfig/kxgettext.c
@@ -166,7 +166,7 @@ static int message__add(const char *msg, char *option, char *file, int lineno)
 	return rc;
 }
 
-void menu_build_message_list(struct menu *menu)
+static void menu_build_message_list(struct menu *menu)
 {
 	struct menu *child;
 
@@ -211,7 +211,7 @@ static void message__print_gettext_msgid_msgstr(struct message *self)
 	       "msgstr \"\"\n", self->msg);
 }
 
-void menu__xgettext(void)
+static void menu__xgettext(void)
 {
 	struct message *m = message__list;
 
diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index 07ff8d1..9930ff2 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -74,7 +74,7 @@ void menu_end_menu(void)
 	current_menu = current_menu->parent;
 }
 
-struct expr *menu_check_dep(struct expr *e)
+static struct expr *menu_check_dep(struct expr *e)
 {
 	if (!e)
 		return e;
@@ -184,7 +184,7 @@ static int menu_range_valid_sym(struct symbol *sym, struct symbol *sym2)
 	       (sym2->type == S_UNKNOWN && sym_string_valid(sym, sym2->name));
 }
 
-void sym_check_prop(struct symbol *sym)
+static void sym_check_prop(struct symbol *sym)
 {
 	struct property *prop;
 	struct symbol *sym2;
diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index 18f3e5c..6c8fbbb 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -36,7 +36,7 @@ tristate modules_val;
 
 struct expr *sym_env_list;
 
-void sym_add_default(struct symbol *sym, const char *def)
+static void sym_add_default(struct symbol *sym, const char *def)
 {
 	struct property *prop = prop_alloc(P_DEFAULT, sym);
 
@@ -125,7 +125,7 @@ struct property *sym_get_default_prop(struct symbol *sym)
 	return NULL;
 }
 
-struct property *sym_get_range_prop(struct symbol *sym)
+static struct property *sym_get_range_prop(struct symbol *sym)
 {
 	struct property *prop;
 
@@ -943,7 +943,7 @@ const char *prop_get_type_name(enum prop_type type)
 	return "unknown";
 }
 
-void prop_add_env(const char *env)
+static void prop_add_env(const char *env)
 {
 	struct symbol *sym, *sym2;
 	struct property *prop;
-- 
1.6.0.4


