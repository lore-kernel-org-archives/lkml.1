Return-Path: <linux-kernel-owner+w=401wt.eu-S1752059AbZKOHQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbZKOHQE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 02:16:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbZKOHOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 02:14:07 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:40952 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbZKOHN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 02:13:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=RR39D+MBIdXdlB5oWHn2mABcN6DT6skhgN6ADuRCws+JCNeAGQ+RqC6mxwq8rvY9c8
         7Xn4T+dIbUtoADxvxK3FivLZXE4XbTt45c+UduqK6+8PUvcb0dbP6fg6VawFfSx8a6ti
         1KgZLYTOknmDfjyHQFMt7EG2hELO8qgg2mRco=
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
To: "linux list" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
Cc: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Subject: [PATCH v5 03/12] vsprintf: give it some care to please checkpatch.pl
Date: Sat, 14 Nov 2009 05:11:51 -0200
Message-Id: <ff3e9244084e2793c8396efe7562aa68db4d8c02.1258181837.git.andre.goddard@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e.dirty
In-Reply-To: <cover.1258181836.git.andre.goddard@gmail.com>
References: <cover.1258181836.git.andre.goddard@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most relevant complaints were addressed.

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 lib/vsprintf.c |  186 ++++++++++++++++++++++++++++++--------------------------
 1 files changed, 99 insertions(+), 87 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 1e08b0d..84fa8f4 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -9,7 +9,7 @@
  * Wirzenius wrote this portably, Torvalds fucked it up :-)
  */
 
-/* 
+/*
  * Fri Jul 13 2001 Crutcher Dunnavant <crutcher+kernel@datastacks.com>
  * - changed to provide snprintf and vsnprintf functions
  * So Feb  1 16:51:32 CET 2004 Juergen Quade <quade@hsnr.de>
@@ -71,9 +71,9 @@ unsigned long simple_strtoul(const char *cp, char **endp, unsigned int base)
 		result = result * base + value;
 		cp++;
 	}
-
 	if (endp)
 		*endp = (char *)cp;
+
 	return result;
 }
 EXPORT_SYMBOL(simple_strtoul);
@@ -86,8 +86,9 @@ EXPORT_SYMBOL(simple_strtoul);
  */
 long simple_strtol(const char *cp, char **endp, unsigned int base)
 {
-	if(*cp == '-')
+	if (*cp == '-')
 		return -simple_strtoul(cp + 1, endp, base);
+
 	return simple_strtoul(cp, endp, base);
 }
 EXPORT_SYMBOL(simple_strtol);
@@ -117,9 +118,9 @@ unsigned long long simple_strtoull(const char *cp, char **endp, unsigned int bas
 		result = result * base + value;
 		cp++;
 	}
-
 	if (endp)
 		*endp = (char *)cp;
+
 	return result;
 }
 EXPORT_SYMBOL(simple_strtoull);
@@ -132,8 +133,9 @@ EXPORT_SYMBOL(simple_strtoull);
  */
 long long simple_strtoll(const char *cp, char **endp, unsigned int base)
 {
-	if(*cp=='-')
+	if (*cp == '-')
 		return -simple_strtoull(cp + 1, endp, base);
+
 	return simple_strtoull(cp, endp, base);
 }
 
@@ -173,6 +175,7 @@ int strict_strtoul(const char *cp, unsigned int base, unsigned long *res)
 	val = simple_strtoul(cp, &tail, base);
 	if (tail == cp)
 		return -EINVAL;
+
 	if ((*tail == '\0') ||
 		((len == (size_t)(tail - cp) + 1) && (*tail == '\n'))) {
 		*res = val;
@@ -285,10 +288,11 @@ EXPORT_SYMBOL(strict_strtoll);
 
 static int skip_atoi(const char **s)
 {
-	int i=0;
+	int i = 0;
 
 	while (isdigit(**s))
 		i = i*10 + *((*s)++) - '0';
+
 	return i;
 }
 
@@ -302,7 +306,7 @@ static int skip_atoi(const char **s)
 /* Formats correctly any integer in [0,99999].
  * Outputs from one to five digits depending on input.
  * On i386 gcc 4.1.2 -O2: ~250 bytes of code. */
-static char* put_dec_trunc(char *buf, unsigned q)
+static char *put_dec_trunc(char *buf, unsigned q)
 {
 	unsigned d3, d2, d1, d0;
 	d1 = (q>>4) & 0xf;
@@ -331,14 +335,15 @@ static char* put_dec_trunc(char *buf, unsigned q)
 				d3 = d3 - 10*q;
 				*buf++ = d3 + '0';  /* next digit */
 				if (q != 0)
-					*buf++ = q + '0';  /* most sign. digit */
+					*buf++ = q + '0'; /* most sign. digit */
 			}
 		}
 	}
+
 	return buf;
 }
 /* Same with if's removed. Always emits five digits */
-static char* put_dec_full(char *buf, unsigned q)
+static char *put_dec_full(char *buf, unsigned q)
 {
 	/* BTW, if q is in [0,9999], 8-bit ints will be enough, */
 	/* but anyway, gcc produces better code with full-sized ints */
@@ -347,14 +352,15 @@ static char* put_dec_full(char *buf, unsigned q)
 	d2 = (q>>8) & 0xf;
 	d3 = (q>>12);
 
-	/* Possible ways to approx. divide by 10 */
-	/* gcc -O2 replaces multiply with shifts and adds */
-	// (x * 0xcd) >> 11: 11001101 - shorter code than * 0x67 (on i386)
-	// (x * 0x67) >> 10:  1100111
-	// (x * 0x34) >> 9:    110100 - same
-	// (x * 0x1a) >> 8:     11010 - same
-	// (x * 0x0d) >> 7:      1101 - same, shortest code (on i386)
-
+	/*
+	 * Possible ways to approx. divide by 10
+	 * gcc -O2 replaces multiply with shifts and adds
+	 * (x * 0xcd) >> 11: 11001101 - shorter code than * 0x67 (on i386)
+	 * (x * 0x67) >> 10:  1100111
+	 * (x * 0x34) >> 9:    110100 - same
+	 * (x * 0x1a) >> 8:     11010 - same
+	 * (x * 0x0d) >> 7:      1101 - same, shortest code (on i386)
+	 */
 	d0 = 6*(d3 + d2 + d1) + (q & 0xf);
 	q = (d0 * 0xcd) >> 11;
 	d0 = d0 - 10*q;
@@ -375,10 +381,11 @@ static char* put_dec_full(char *buf, unsigned q)
 				d3 = d3 - 10*q;
 				*buf++ = d3 + '0';
 					*buf++ = q + '0';
+
 	return buf;
 }
 /* No inlining helps gcc to use registers better */
-static noinline char* put_dec(char *buf, unsigned long long num)
+static noinline char *put_dec(char *buf, unsigned long long num)
 {
 	while (1) {
 		unsigned rem;
@@ -448,9 +455,9 @@ static char *number(char *buf, char *end, unsigned long long num,
 		spec.flags &= ~ZEROPAD;
 	sign = 0;
 	if (spec.flags & SIGN) {
-		if ((signed long long) num < 0) {
+		if ((signed long long)num < 0) {
 			sign = '-';
-			num = - (signed long long) num;
+			num = -(signed long long)num;
 			spec.field_width--;
 		} else if (spec.flags & PLUS) {
 			sign = '+';
@@ -478,7 +485,9 @@ static char *number(char *buf, char *end, unsigned long long num,
 	else if (spec.base != 10) { /* 8 or 16 */
 		int mask = spec.base - 1;
 		int shift = 3;
-		if (spec.base == 16) shift = 4;
+
+		if (spec.base == 16)
+			shift = 4;
 		do {
 			tmp[i++] = (digits[((unsigned char)num) & mask] | locase);
 			num >>= shift;
@@ -493,7 +502,7 @@ static char *number(char *buf, char *end, unsigned long long num,
 	/* leading space padding */
 	spec.field_width -= spec.precision;
 	if (!(spec.flags & (ZEROPAD+LEFT))) {
-		while(--spec.field_width >= 0) {
+		while (--spec.field_width >= 0) {
 			if (buf < end)
 				*buf = ' ';
 			++buf;
@@ -543,6 +552,7 @@ static char *number(char *buf, char *end, unsigned long long num,
 			*buf = ' ';
 		++buf;
 	}
+
 	return buf;
 }
 
@@ -572,6 +582,7 @@ static char *string(char *buf, char *end, const char *s, struct printf_spec spec
 			*buf = ' ';
 		++buf;
 	}
+
 	return buf;
 }
 
@@ -585,11 +596,13 @@ static char *symbol_string(char *buf, char *end, void *ptr,
 		sprint_symbol(sym, value);
 	else
 		kallsyms_lookup(value, NULL, NULL, NULL, sym);
+
 	return string(buf, end, sym, spec);
 #else
-	spec.field_width = 2*sizeof(void *);
+	spec.field_width = 2 * sizeof(void *);
 	spec.flags |= SPECIAL | SMALL | ZEROPAD;
 	spec.base = 16;
+
 	return number(buf, end, value, spec);
 #endif
 }
@@ -609,7 +622,7 @@ static char *resource_string(char *buf, char *end, struct resource *res,
 		.precision = -1,
 		.flags = SPECIAL | SMALL | ZEROPAD,
 	};
-	/* room for the actual numbers, the two "0x", -, [, ] and the final zero */
+	/* room for actual numbers: the two "0x", -, [, ] and the final zero */
 	char sym[4*sizeof(resource_size_t) + 8];
 	char *p = sym, *pend = sym + sizeof(sym);
 	int size = -1;
@@ -666,22 +679,19 @@ static char *ip4_string(char *p, const u8 *addr, bool leading_zeros)
 		if (i < 3)
 			*p++ = '.';
 	}
-
 	*p = '\0';
+
 	return p;
 }
 
 static char *ip6_compressed_string(char *p, const char *addr)
 {
-	int i;
-	int j;
-	int range;
+	int i, j, range;
 	unsigned char zerolength[8];
 	int longest = 1;
 	int colonpos = -1;
 	u16 word;
-	u8 hi;
-	u8 lo;
+	u8 hi, lo;
 	bool needcolon = false;
 	bool useIPv4;
 	struct in6_addr in6;
@@ -748,22 +758,23 @@ static char *ip6_compressed_string(char *p, const char *addr)
 			*p++ = ':';
 		p = ip4_string(p, &in6.s6_addr[12], false);
 	}
-
 	*p = '\0';
+
 	return p;
 }
 
 static char *ip6_string(char *p, const char *addr, const char *fmt)
 {
 	int i;
+
 	for (i = 0; i < 8; i++) {
 		p = pack_hex_byte(p, *addr++);
 		p = pack_hex_byte(p, *addr++);
 		if (fmt[0] == 'I' && i != 7)
 			*p++ = ':';
 	}
-
 	*p = '\0';
+
 	return p;
 }
 
@@ -1269,7 +1280,8 @@ int vscnprintf(char *buf, size_t size, const char *fmt, va_list args)
 {
 	int i;
 
-	i=vsnprintf(buf,size,fmt,args);
+	i = vsnprintf(buf, size, fmt, args);
+
 	return (i >= size) ? (size - 1) : i;
 }
 EXPORT_SYMBOL(vscnprintf);
@@ -1288,14 +1300,15 @@ EXPORT_SYMBOL(vscnprintf);
  *
  * See the vsnprintf() documentation for format string extensions over C99.
  */
-int snprintf(char * buf, size_t size, const char *fmt, ...)
+int snprintf(char *buf, size_t size, const char *fmt, ...)
 {
 	va_list args;
 	int i;
 
 	va_start(args, fmt);
-	i=vsnprintf(buf,size,fmt,args);
+	i = vsnprintf(buf, size, fmt, args);
 	va_end(args);
+
 	return i;
 }
 EXPORT_SYMBOL(snprintf);
@@ -1311,7 +1324,7 @@ EXPORT_SYMBOL(snprintf);
  * the trailing '\0'. If @size is <= 0 the function returns 0.
  */
 
-int scnprintf(char * buf, size_t size, const char *fmt, ...)
+int scnprintf(char *buf, size_t size, const char *fmt, ...)
 {
 	va_list args;
 	int i;
@@ -1319,6 +1332,7 @@ int scnprintf(char * buf, size_t size, const char *fmt, ...)
 	va_start(args, fmt);
 	i = vsnprintf(buf, size, fmt, args);
 	va_end(args);
+
 	return (i >= size) ? (size - 1) : i;
 }
 EXPORT_SYMBOL(scnprintf);
@@ -1356,14 +1370,15 @@ EXPORT_SYMBOL(vsprintf);
  *
  * See the vsnprintf() documentation for format string extensions over C99.
  */
-int sprintf(char * buf, const char *fmt, ...)
+int sprintf(char *buf, const char *fmt, ...)
 {
 	va_list args;
 	int i;
 
 	va_start(args, fmt);
-	i=vsnprintf(buf, INT_MAX, fmt, args);
+	i = vsnprintf(buf, INT_MAX, fmt, args);
 	va_end(args);
+
 	return i;
 }
 EXPORT_SYMBOL(sprintf);
@@ -1421,7 +1436,6 @@ do {									\
 	str += sizeof(type);						\
 } while (0)
 
-
 	while (*fmt) {
 		read = format_decode(fmt, &spec);
 
@@ -1509,8 +1523,8 @@ do {									\
 			}
 		}
 	}
-	return (u32 *)(PTR_ALIGN(str, sizeof(u32))) - bin_buf;
 
+	return (u32 *)(PTR_ALIGN(str, sizeof(u32))) - bin_buf;
 #undef save_arg
 }
 EXPORT_SYMBOL_GPL(vbin_printf);
@@ -1542,7 +1556,6 @@ int bstr_printf(char *buf, size_t size, const char *fmt, const u32 *bin_buf)
 	unsigned long long num;
 	char *str, *end, c;
 	const char *args = (const char *)bin_buf;
-
 	struct printf_spec spec = {0};
 
 	if (WARN_ON_ONCE((int) size < 0))
@@ -1722,6 +1735,7 @@ int bprintf(u32 *bin_buf, size_t size, const char *fmt, ...)
 	va_start(args, fmt);
 	ret = vbin_printf(bin_buf, size, fmt, args);
 	va_end(args);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(bprintf);
@@ -1734,18 +1748,16 @@ EXPORT_SYMBOL_GPL(bprintf);
  * @fmt:	format of buffer
  * @args:	arguments
  */
-int vsscanf(const char * buf, const char * fmt, va_list args)
+int vsscanf(const char *buf, const char *fmt, va_list args)
 {
 	const char *str = buf;
 	char *next;
 	char digit;
 	int num = 0;
-	int qualifier;
-	int base;
-	int field_width;
+	int qualifier, base, field_width;
 	int is_sign = 0;
 
-	while(*fmt && *str) {
+	while (*fmt && *str) {
 		/* skip any white space in format */
 		/* white space in format matchs any amount of
 		 * white space, including none, in the input.
@@ -1767,7 +1779,7 @@ int vsscanf(const char * buf, const char * fmt, va_list args)
 		if (!*fmt)
 			break;
 		++fmt;
-		
+
 		/* skip this conversion.
 		 * advance both strings to next white space
 		 */
@@ -1805,10 +1817,10 @@ int vsscanf(const char * buf, const char * fmt, va_list args)
 		if (!*fmt || !*str)
 			break;
 
-		switch(*fmt++) {
+		switch (*fmt++) {
 		case 'c':
 		{
-			char *s = (char *) va_arg(args,char*);
+			char *s = (char *)va_arg(args, char*);
 			if (field_width == -1)
 				field_width = 1;
 			do {
@@ -1819,17 +1831,16 @@ int vsscanf(const char * buf, const char * fmt, va_list args)
 		continue;
 		case 's':
 		{
-			char *s = (char *) va_arg(args, char *);
-			if(field_width == -1)
+			char *s = (char *)va_arg(args, char *);
+			if (field_width == -1)
 				field_width = INT_MAX;
 			/* first, skip leading white space in buffer */
 			while (isspace(*str))
 				str++;
 
 			/* now copy until next white space */
-			while (*str && !isspace(*str) && field_width--) {
+			while (*str && !isspace(*str) && field_width--)
 				*s++ = *str++;
-			}
 			*s = '\0';
 			num++;
 		}
@@ -1837,7 +1848,7 @@ int vsscanf(const char * buf, const char * fmt, va_list args)
 		case 'n':
 			/* return number of characters read so far */
 		{
-			int *i = (int *)va_arg(args,int*);
+			int *i = (int *)va_arg(args, int*);
 			*i = str - buf;
 		}
 		continue;
@@ -1849,14 +1860,14 @@ int vsscanf(const char * buf, const char * fmt, va_list args)
 			base = 16;
 			break;
 		case 'i':
-                        base = 0;
+			base = 0;
 		case 'd':
 			is_sign = 1;
 		case 'u':
 			break;
 		case '%':
 			/* looking for '%' in str */
-			if (*str++ != '%') 
+			if (*str++ != '%')
 				return num;
 			continue;
 		default:
@@ -1875,63 +1886,63 @@ int vsscanf(const char * buf, const char * fmt, va_list args)
 			digit = *(str + 1);
 
 		if (!digit
-                    || (base == 16 && !isxdigit(digit))
-                    || (base == 10 && !isdigit(digit))
-                    || (base == 8 && (!isdigit(digit) || digit > '7'))
-                    || (base == 0 && !isdigit(digit)))
-				break;
+		    || (base == 16 && !isxdigit(digit))
+		    || (base == 10 && !isdigit(digit))
+		    || (base == 8 && (!isdigit(digit) || digit > '7'))
+		    || (base == 0 && !isdigit(digit)))
+			break;
 
-		switch(qualifier) {
+		switch (qualifier) {
 		case 'H':	/* that's 'hh' in format */
 			if (is_sign) {
-				signed char *s = (signed char *) va_arg(args,signed char *);
-				*s = (signed char) simple_strtol(str,&next,base);
+				signed char *s = (signed char *)va_arg(args, signed char *);
+				*s = (signed char)simple_strtol(str, &next, base);
 			} else {
-				unsigned char *s = (unsigned char *) va_arg(args, unsigned char *);
-				*s = (unsigned char) simple_strtoul(str, &next, base);
+				unsigned char *s = (unsigned char *)va_arg(args, unsigned char *);
+				*s = (unsigned char)simple_strtoul(str, &next, base);
 			}
 			break;
 		case 'h':
 			if (is_sign) {
-				short *s = (short *) va_arg(args,short *);
-				*s = (short) simple_strtol(str,&next,base);
+				short *s = (short *)va_arg(args, short *);
+				*s = (short)simple_strtol(str, &next, base);
 			} else {
-				unsigned short *s = (unsigned short *) va_arg(args, unsigned short *);
-				*s = (unsigned short) simple_strtoul(str, &next, base);
+				unsigned short *s = (unsigned short *)va_arg(args, unsigned short *);
+				*s = (unsigned short)simple_strtoul(str, &next, base);
 			}
 			break;
 		case 'l':
 			if (is_sign) {
-				long *l = (long *) va_arg(args,long *);
-				*l = simple_strtol(str,&next,base);
+				long *l = (long *)va_arg(args, long *);
+				*l = simple_strtol(str, &next, base);
 			} else {
-				unsigned long *l = (unsigned long*) va_arg(args,unsigned long*);
-				*l = simple_strtoul(str,&next,base);
+				unsigned long *l = (unsigned long *)va_arg(args, unsigned long *);
+				*l = simple_strtoul(str, &next, base);
 			}
 			break;
 		case 'L':
 			if (is_sign) {
-				long long *l = (long long*) va_arg(args,long long *);
-				*l = simple_strtoll(str,&next,base);
+				long long *l = (long long *)va_arg(args, long long *);
+				*l = simple_strtoll(str, &next, base);
 			} else {
-				unsigned long long *l = (unsigned long long*) va_arg(args,unsigned long long*);
-				*l = simple_strtoull(str,&next,base);
+				unsigned long long *l = (unsigned long long *)va_arg(args, unsigned long long *);
+				*l = simple_strtoull(str, &next, base);
 			}
 			break;
 		case 'Z':
 		case 'z':
 		{
-			size_t *s = (size_t*) va_arg(args,size_t*);
-			*s = (size_t) simple_strtoul(str,&next,base);
+			size_t *s = (size_t *)va_arg(args, size_t *);
+			*s = (size_t)simple_strtoul(str, &next, base);
 		}
 		break;
 		default:
 			if (is_sign) {
-				int *i = (int *) va_arg(args, int*);
-				*i = (int) simple_strtol(str,&next,base);
+				int *i = (int *)va_arg(args, int *);
+				*i = (int)simple_strtol(str, &next, base);
 			} else {
-				unsigned int *i = (unsigned int*) va_arg(args, unsigned int*);
-				*i = (unsigned int) simple_strtoul(str,&next,base);
+				unsigned int *i = (unsigned int *)va_arg(args, unsigned int*);
+				*i = (unsigned int)simple_strtoul(str, &next, base);
 			}
 			break;
 		}
@@ -1962,14 +1973,15 @@ EXPORT_SYMBOL(vsscanf);
  * @fmt:	formatting of buffer
  * @...:	resulting arguments
  */
-int sscanf(const char * buf, const char * fmt, ...)
+int sscanf(const char *buf, const char *fmt, ...)
 {
 	va_list args;
 	int i;
 
-	va_start(args,fmt);
-	i = vsscanf(buf,fmt,args);
+	va_start(args, fmt);
+	i = vsscanf(buf, fmt, args);
 	va_end(args);
+
 	return i;
 }
 EXPORT_SYMBOL(sscanf);
-- 
1.6.5.2.180.gc5b3e.dirty

