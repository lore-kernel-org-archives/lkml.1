Return-Path: <linux-kernel-owner+w=401wt.eu-S932725AbZJPPqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932725AbZJPPqO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 11:46:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760234AbZJPPqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 11:46:11 -0400
Received: from mail-iw0-f178.google.com ([209.85.223.178]:43272 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760602AbZJPPqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 11:46:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type;
        b=gZSy2jFwYuGeXonv7iLqYFULGLyBLZGRZGPL4tGUA0gZuW1enRy1QDiZbOlzX46O8u
         lIiRI67q5+LAxnke4cvq92jUHKAXGgnHWuVtFjbvgzF5DCF7YNyDIbf1R6c5G63xiTGP
         nUNbFe6DcCsYs0EeKQHk05BmOA0JA0StyO/1Q=
MIME-Version: 1.0
Date: Fri, 16 Oct 2009 08:45:31 -0700
X-Google-Sender-Auth: 1cf6be0915f6021b
Message-ID: <70318cbf0910160845g51baf4dbtff57b81cfb1c7538@mail.gmail.com>
Subject: Sparse 0.4.2 released
From: Christopher Li <sparse@chrisli.org>
To: Linux-Sparse <linux-sparse@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have tagged and released the sparse version 0.4.2 at
http://www.kernel.org/pub/software/devel/sparse/dist/sparse-0.4.2.tar.gz

As previous discussions on the sparse mailing list, I am the new maintainer of
the sparse project. This is my first release for sparse.
Thanks Josh Triplett for the previously maintaining the project.

I also created a new sparse wiki, it will replace the current sparse
home page. http://sparse.wiki.kernel.org/index.php/Main_Page

A lot of bug fixes and enhancements have gone into this release.
Special thanks to Al Viro for overhauling the parser. Now sparse
has  better ctype and attribute handling. The detailed changes follow.

Chris


 .gitignore                                       |    6 +
 Documentation/data-structures.txt                |   54 +
 Makefile                                         |  162 +--
 cgcc                                             |   47 +-
 compat-bsd.c                                     |   20 +
 compile-i386.c                                   |   10 +-
 compile.h                                        |    2 +
 evaluate.c                                       |  141 ++-
 example.c                                        |    2 +-
 expand.c                                         |   11 +-
 expression.c                                     |   66 +-
 expression.h                                     |    4 +-
 flow.c                                           |   10 +-
 flow.h                                           |    6 +
 gdbhelpers                                       |  307 +++++
 ident-list.h                                     |    5 +
 lib.c                                            |  242 ++++-
 lib.h                                            |    5 +-
 linearize.c                                      |   16 +-
 linearize.h                                      |    3 +-
 liveness.c                                       |    2 +-
 parse.c                                          | 1367 +++++++++++++++-------
 parse.h                                          |    3 +-
 pre-process.c                                    |  126 ++-
 ptrlist.h                                        |    2 +
 scope.c                                          |    2 +-
 scope.h                                          |    2 +
 show-parse.c                                     |  110 +-
 simplify.c                                       |   57 +-
 sparse.1                                         |   22 +
 storage.h                                        |    3 +
 symbol.c                                         |   84 +-
 symbol.h                                         |   86 ++-
 target.c                                         |    1 +
 target.h                                         |   15 +
 token.h                                          |    3 +-
 tokenize.c                                       |   41 +-
 unssa.c                                          |    2 +
 validation/address_space.c                       |    6 +-
 validation/attr-warning.c                        |    8 +
 validation/attr_in_parameter.c                   |   12 +
 validation/bad-array-designated-initializer.c    |    6 +-
 validation/bad-assignment.c                      |    4 +-
 validation/bad-cast.c                            |    6 +-
 validation/bad-ternary-cond.c                    |    4 +-
 validation/bad-typeof.c                          |   14 +
 validation/badtype4.c                            |    4 +-
 validation/check_byte_count-ice.c                |    4 +-
 validation/compare-null-to-int.c                 |    2 +-
 validation/cond_expr.c                           |    4 +-
 validation/cond_expr2.c                          |   12 +-
 validation/context.c                             |    6 +-
 validation/declaration-after-statement-ansi.c    |   12 +
 validation/declaration-after-statement-c89.c     |   12 +
 validation/declaration-after-statement-c99.c     |    9 +
 validation/declaration-after-statement-default.c |    9 +
 validation/definitions.c                         |   12 +
 validation/dubious-bitwise-with-not.c            |   24 +
 validation/enum_scope.c                          |   11 +
 validation/extern-inline.c                       |   23 +
 validation/identifier_list.c                     |   18 +
 validation/initializer-entry-defined-twice.c     |    8 +-
 validation/label-scope.c                         |   12 +
 validation/missing-ident.c                       |   18 +
 validation/multi_typedef.c                       |   15 +
 validation/nested-declarator.c                   |   29 +
 validation/nested-declarator2.c                  |   41 +
 validation/noderef.c                             |    6 +-
 validation/preprocessor/preprocessor11.c         |   21 +
 validation/preprocessor/preprocessor12.c         |   11 +
 validation/preprocessor/preprocessor13.c         |   16 +
 validation/preprocessor/preprocessor14.c         |   10 +
 validation/preprocessor/preprocessor15.c         |    9 +
 validation/preprocessor/preprocessor16.c         |    9 +
 validation/preprocessor/preprocessor22.c         |   35 +
 validation/preprocessor/preprocessor7.c          |    9 +
 validation/preprocessor/preprocessor8.c          |   22 +
 validation/reserved.c                            |   40 +
 validation/restrict-array.c                      |   12 +
 validation/sizeof-compound-postfix.c             |    8 +
 validation/specifiers1.c                         |  101 ++
 validation/specifiers2.c                         |  152 +++
 validation/test-suite                            |    6 +-
 validation/typedef_shadow.c                      |   12 +
 validation/typeof-attribute.c                    |   16 +
 validation/typesign.c                            |   36 +-
 86 files changed, 3011 insertions(+), 912 deletions(-)


Al Viro (39):
      saner warnings for restricted types
      fix show_typename()
      catch !x & y brainos
      fun with declarations and definitions
      Fix type_info_expression()
      fun with declarations and definitions
      Fix handling of ident-less declarations
      Separate parsing of identifier-list (in K&R-style declarations)
      More nested declarator fixes
      Fix attribute/asm handling
      more direct_declarator() sanitizing
      Warn about non-empty identifier list outside of definition
      Apply attributes after ( to the right place
      Leave applying attributes until we know whether it's a nested declarator
      Don't mess with passing symbol to declarator/direct_declarator
      Fix braino in which_kind()
      Sanitize direct_declarator logics
      Separating ctype and parser state, part 1
      Propagate decl_state to declaration_specifiers()
      Fix regression created by commit af30c6df74f01db10fa78ac0cbdb5c3c40b5c73f
      Take the rest of storage class keywords to parse.c
      Fix handling of typedefs with several declarators
      preparations to ->declarator() cleanup - separate typedef handling
      Take the rest of specifiers to parse.c
      Saner type for __builtin_va_list
      Rewrite and fix specifiers handling
      Have ->declarator() act directly on ctype being affected
      Clean up and split declaration_specifiers()
      Pass decl_state down to ->declarator() and handle_attributes()
      Pass decl_state down to ->attribute()
      Restore __attribute__((mode)) handling
      Fix enumeration constants' scope beginning
      Fix declaration_specifiers() handling of typedef name shadowed
by NS_SYMBOL
      Fix __label__ handling
      Simplify get_number_value() and ctype_integer()
      Don't mix storage class bits with ctype->modifiers while parsing type
      Sanitize pointer()
      Segfault at evaluate.c:341
      warn directive in argument list

Alberto Bertogli (1):
      Support the __thread storage class

Alexander Shishkin (1):
      don't call sparse when called to generate dependencies

Alexey Zaytsev (16):
      Remove symbol.id_list
      Replace the -specs cgcc option with -target
      Make show_symbol newline-consistent
      Handle a terminal -o option properly.
      Looks more evident this way.
      Mark handle_switch as static and don't export it from lib.h
      Handle missing argument to -D.
      Gdb macros to get a better look at some sparse data structures.
      A slightly edited irc discussion with Josh Triplett.
      Warning should be enough for an unhandled transparent union
      Set gcc include path at runtime.
      Let cgcc pass -gcc-base-dir to sparse.
      Document -gcc-base-dir in sparse.1
      Rename dirafter to idirafter.
      Let void have sizeof 1
      Also warn about sizeof(function)

Blue Swirl (6):
      Sparc64 (Sparc V9, LP64) support
      OpenBSD support
      Ignore attribute __bounded__, used by OpenBSD headers.
      Add c{l,t}z{,l,ll}, ffsl{,l}, popcountll and floating point
comparison builtins.
      Add support for TImode type (__int128_t)
      Define __LP64__ for x86_64 unless in 32 bit mode

Christopher Li (11):
      Evaluate iterator symbols
      Remove pre_buffer
      Add enum member list to the parent
      Teach classify_type to handle typeof
      Warn about explicit usage of sizeof(void)
      Makefile automatic header dependency
      Clean up Makefile long lines
      Update the validation check for ftabstop=
      Add validation for restrict and attribute warning
      move extern inline function to file scope
      Sparse 0.4.2

David Given (2):
      Unhardcode byte size being 8 bits.
      Add type information to struct instruction.

Geoff Johnstone (4):
      Add support for GCC's -std=... and -ansi command line options.
      Add builtin functions for use with __FORTIFY_SOURCE
      Fix type mismatches with incomplete types
      Add -Wno-declaration-after-statement

Hannes Eder (4):
      Add -ftabstop=WIDTH
      refactor handle_switch_f
      test-suite: be more verbose on 'unhandled' and 'known to fail' tests
      test-suite: integrate unhandled proprocessor tests

Johannes Berg (8):
      cgcc: handle ppc arch
      make sparse keep its promise about context tracking
      sparse test suite: add test mixing __context__ and
__attribute__((context(...)))
      sparse: simple conditional context tracking
      inlined call bugfix & test
      improve -Wcontext code and messages
      fix bug in context tracking code
      Revert the context tracking code

Josh Triplett (2):
      Add test case for new warning about !x & y
      Expand "dubious !x & y" handling to other combinations of !, &, and |.

Kamil Dudka (4):
      compile-i386: do not generate an infinite loop
      linearize.h: sanitize header
      unssa: track uses when replacing a phi node
      make sparse headers self-compilable...

Linus Torvalds (5):
      Fix cast instruction generation
      Simplify (and warn about) right shifts that result in zero
      Allow array declarators to have 'restrict' in them
      Turn off '-Wtransparent-union' by default
      Avoid "attribute 'warning': unknown attribute" warning

Martin Nagy (3):
      .gitignore: Ignore dependencies and Vim swap files
      Add missing checks for Waddress-space
      Print an error if typeof() lacks an argument

Pavel Roskin (1):
      Ignore "cold" and "hot" attributes, which appeared in gcc 4.3

Pekka Enberg (1):
      sparse: Add GCC pre-defined macros for user-space

Ramsay Jones (1):
      Makefile: suppress error message from pkg-config

Reinhard Tartler (1):
      show_token: handle TOKEN_UNTAINT and TOKEN_ARG_COUNT types

Samuel Bronson (1):
      Have Makefile import local.mk if it exists.

Thomas Schmid (1):
      Fix implicit cast to float

Vegard Nossum (2):
      Fix use of invalid file descriptor
      Set *tree to NULL on error
